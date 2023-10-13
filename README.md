# Nuclei Spider
Idea stolen from https://github.com/0xKayala/NucleiFuzzer  
But I made it more clean and add favor to my personal used environment

# Prerequisite
`Python 3.5` or above and `Pip3`
```
sudo apt install python3 python3-pip
```
`Golang` > `go1.21.1`
### If you are using kali
```
sudo apt install golang
```
### If you are like me, using Linux Mint / Ubuntu
```
sudo snap install go --classic
```
### Once you have Golang, you can proceed to install the necessarily tools:
### Nuclei
- https://github.com/projectdiscovery/nuclei
```
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
```
### Now you have Nuclei, the rest below are optional because they are already automated in the script `uwu.sh`
Chown `/opt/` directory to have write permission as current user
```
sudo chown -R /opt <username>
```
Make a `nuclei` directory inside `/opt/` and install templates and `ParamSpider`
```
mkdir /opt/nuclei
git clone https://github.com/projectdiscovery/fuzzing-templates.git /opt/nuclei/fuzzing-templates
git clone https://github.com/projectdiscovery/nuclei-templates.git /opt/nuclei/nuclei-templates
git clone https://github.com/devanshbatham/ParamSpider.git
pip3 install ParamSpider/
sleep 1
rm -rf ParamSpider/
```
### Lastly change the following file and line to the `/opt/nuclei` directory
```
nano ~/.config/nuclei/.templates-config.json
```
Yes yes this line
```
"nuclei-templates-directory":"/opt/nuclei/nuclei-templates"
```
### Pretty much that's it, now you can `wget` the `uwu.sh` script and move to your `/usr/bin`
```
wget https://raw.githubusercontent.com/zyairelai/nuclei-spider/main/uwu.sh
chmod a+x uwu.sh
sudo mv uwu.sh /usr/bin/nucleispider
```

# What this thingy does?
- It use `ParamSpider` to crawl the domain URL and its endpoints from wayback archive
- Then all the paramater will be replaced with `FUZZ`
- Using Nuclei fuzzing template to fuzz all the `FUZZ` parameters to identify XSS, SQLi, Command Injection etc
