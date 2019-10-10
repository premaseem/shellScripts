Readme.md

Use below commands to password protect your file or enycript your file with symetric key encription. 

1. Create a sample file

   echo "This is my secret message" > message.txt

2. Encrypt a file

   openssl enc -aes-256-cbc -in message.txt -out message.txt.enc

3. Decrypt a file
   
  openssl enc -aes-256-cbc -d -in message.txt.enc -pass pass:myPassword