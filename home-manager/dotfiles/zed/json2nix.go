package main

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

var nixIdentifier = regexp.MustCompile(`^[a-zA-Z_][a-zA-Z0-9_-]*$`)

type Converter struct {
	buf strings.Builder
}

func (c *Converter) reset() {
	c.buf.Reset()
}

func (c *Converter) indent(level int) {
	for i := 0; i < level*2; i++ {
		c.buf.WriteByte(' ')
	}
}

func (c *Converter) writeString(s string) {
	c.buf.WriteByte('"')
	for _, r := range s {
		switch r {
		case '"':
			c.buf.WriteString(`\"`)
		case '\\':
			c.buf.WriteString(`\\`)
		case '\n':
			c.buf.WriteString(`\n`)
		case '\r':
			c.buf.WriteString(`\r`)
		case '\t':
			c.buf.WriteString(`\t`)
		default:
			c.buf.WriteRune(r)
		}
	}
	c.buf.WriteByte('"')
}

func (c *Converter) writeValue(v any, level int) {
	switch val := v.(type) {
	case nil:
		c.buf.WriteString("null")
	case bool:
		c.buf.WriteString(strconv.FormatBool(val))
	case float64:
		if val == float64(int64(val)) {
			c.buf.WriteString(strconv.FormatInt(int64(val), 10))
		} else {
			c.buf.WriteString(strconv.FormatFloat(val, 'g', -1, 64))
		}
	case string:
		c.writeString(val)
	case []any:
		c.writeArray(val, level)
	case map[string]any:
		c.writeObject(val, level)
	}
}

func (c *Converter) writeArray(arr []any, level int) {
	if len(arr) == 0 {
		c.buf.WriteString("[ ]")
		return
	}

	c.buf.WriteString("[\n")
	for _, item := range arr {
		c.indent(level + 1)
		c.writeValue(item, level+1)
		c.buf.WriteByte('\n')
	}
	c.indent(level)
	c.buf.WriteByte(']')
}

func (c *Converter) writeObject(obj map[string]any, level int) {
	if len(obj) == 0 {
		c.buf.WriteString("{ }")
		return
	}

	keys := make([]string, 0, len(obj))
	for k := range obj {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	c.buf.WriteString("{\n")
	for _, key := range keys {
		c.indent(level + 1)

		if nixIdentifier.MatchString(key) {
			c.buf.WriteString(key)
		} else {
			c.writeString(key)
		}

		c.buf.WriteString(" = ")
		c.writeValue(obj[key], level+1)
		c.buf.WriteString(";\n")
	}
	c.indent(level)
	c.buf.WriteByte('}')
}

func (c *Converter) Convert(data []byte, attrName string) (string, error) {
	c.reset()

	var v any
	if err := json.Unmarshal(data, &v); err != nil {
		return "", err
	}

	c.buf.WriteString("{\n  ")
	c.buf.WriteString(attrName)
	c.buf.WriteString(" = ")
	c.writeValue(v, 1)
	c.buf.WriteByte(';')
	c.buf.WriteString("\n}")

	return c.buf.String(), nil
}

func main() {
	var input io.Reader = os.Stdin
	attrName := "userSettings"

	if len(os.Args) > 1 && os.Args[1] != "-" {
		file, err := os.Open(os.Args[1])
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			os.Exit(1)
		}
		defer file.Close()
		input = file
	}

	if len(os.Args) > 2 {
		attrName = os.Args[2]
	}

	data, err := io.ReadAll(input)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	converter := &Converter{}
	result, err := converter.Convert(data, attrName)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	fmt.Println(result)
}
