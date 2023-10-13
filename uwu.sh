#!/bin/bash

directory="/opt"
current_user=$(whoami)

# Chown /opt writable for current user
if [ ! -w "$directory" ]; then
    echo "[+] Run the following command before executing the script"
    echo "[+] sudo chown -R" $directory $current_user
    exit 1
fi

# Check if nuclei is installed
if ! command -v nuclei &> /dev/null; then
    echo "[!] Nuclei is NOT installed!"
    exit 1
fi

# Check if /opt/nuclei exists
if [ ! -d "$directory/nuclei" ]; then
    mkdir -p "$directory/nuclei"
fi

# Check if fuzzing-templates is already cloned.
if [ ! -d "$directory/nuclei/fuzzing-templates" ]; then
    git clone https://github.com/projectdiscovery/fuzzing-templates.git "$directory/nuclei/fuzzing-templates"
fi

# Check if nuclei-templates is already cloned.
if [ ! -d "$directory/nuclei/fuzzing-templates" ]; then
    git clone https://github.com/projectdiscovery/nuclei-templates.git "$directory/nuclei/nuclei-templates"
fi

# Check if ParamSpider is installed, if not, install it
if ! command -v paramspider &> /dev/null; then
    echo "[+] Installing ParamSpider..."
    git clone https://github.com/devanshbatham/ParamSpider.git
    pip3 install ParamSpider/
    sleep 1
    rm -rf ParamSpider/
fi

# Help menu
display_help() {
    echo -e "Usage: $0 [options]\n\n"
    echo "Options:"
    echo "  -h, --help              Display help information"
    echo "  -d, --domain <domain>   Domain to scan for XSS, SQLi, SSRF, etc. vulnerabilities"
    exit 0
}

# Step 1: Parse command line arguments
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -h|--help)
            display_help
            ;;
        -d|--domain)
            domain="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown option: $key"
            display_help
            ;;
    esac
done

# Step 2: Ask the user to enter the domain name
if [ -z "$domain" ]; then
    read -p "Enter the domain name (eg: target.com): " domain
fi

# Step 3: Get the vulnerable parameters of the given domain name using ParamSpider tool and save the output into a text file
echo "Running ParamSpider on $domain"
$(command -v paramspider) -d "$domain"
# $(command -v paramspider) -d "$domain" --exclude png,jpg,gif,jpeg,swf,woff,gif,svg --level high --quiet -o output_paramspider.txt

# Check whether URLs were collected or not
if [ ! -s results/$domain.txt ]; then
    echo "No URLs Found. Exiting..."
    exit 1
fi

# Step 4: Run the Nuclei Fuzzing templates on $domain.txt file
echo "Running Nuclei on results/$domain.txt"
nuclei -l results/$domain.txt -t "$directory/nuclei/fuzzing-templates" -rl 05

# Step 5: End with a general message as the scan is completed
echo "Scan is completed uwu"