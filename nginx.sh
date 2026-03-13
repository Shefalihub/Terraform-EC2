#!bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
echo "<h1> welcome to nginx </h1>" | sudo tee /var/www/html/index.html  

# tee actually used for append the data to create simple web page
