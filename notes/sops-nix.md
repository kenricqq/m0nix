## create age keys
age-keygen -o keys.txt

## password encrypt keys.txt file
age -p -o local-secrets-key.age keys.txt

## view age encrypted file
age -d local-secrets-key.age

## decrypt age into plaintext file
age --decrypt local-secrets-key.age > keys.txt

## create secrets file tied to age public key
sops --age $(age-keygen -y keys.txt) secrets.yaml

