# Theory
## 1
Ports are addresses at which traffic is connected to suitable programs on the machine. Ports are software-based and controlled by the operating system. The number of ports is limited considering 16-bit addressing. Between the protocols User Datagram Protocol (UDP) and Transmission Control Protocol (TCP), there are 65,535 ports available for communication between devices.

## 2
- HTTP is a protocol that describes the rules for transmitting data from a web page and receiving by the server the information that the user entered on   the site.
- HTTPS is the same protocol, but with a security add-on (SSL/TLS).
- SSH is a remote protocol used to securely connect to a remote server and execute commands on it.
- Information is transmitted via HTTP in the usual form, and via HTTPS - in encrypted form.
- SSH uses network tunnels and HTTPS uses digital certificates. SSH authentication is done through server verification, key generation, and user verification by the server, and HTTPS through digital certificate exchange.
- Both SSH and HTTPS are both encrypted connection protocols.

Ports:
1. 20-21: FTP
2. 22: SSH
3. 25: SMTP
4. 80: http
5. 443: https
6. 587: Modern, secure SMTP that uses encryption

## 3
1. An IP address is a string of numbers separated by periods. IP addresses are expressed as a set of four numbers. Each number in the set can range from 0 to 255. IP stands for "Internet Protocol," which is the set of rules governing the format of data sent via the internet or local network. In essence, IP addresses are the identifier that allows information to be sent between devices on a network.
2. A public IP address is an IP address that, unlike private IP, can be accessed directly over the internet and is assigned to your network router by your internet service provider (ISP).
3. First, the browser needs to figure out which server on the Internet to connect to. Using DNS it looks up the IP address of the server hosting the website using the domain. Then, it initiates Transmission Control Protocol (TCP) with the server. After that the browser sends the HTTP request to the server. The server processes request and sends back a response. Fibally, the browser renders the content.

## 4
Nginx is a tool that optimizes memory usage and parallelizes processes. Instead of creating new processes for each web request, Nginx uses an asynchronous approach where requests are processed on a single thread. In Nginx, one master process can manage multiple worker processes.

Alternatives:
1. Apache HTTP Server
2. Caddy
3. Varnish.

## 5
SSH is a remote protocol used to securely connect to a remote server and execute commands on it. There are two ways to authenticate:

- Password-Based Authentication:
After establishing a secure connection to remote servers, SSH users pass their usernames and passwords to the remote servers for client authentication. The credentials are passed through a secure tunnel, the server checks them against the database and authenticates the client.

- Public Key Authentication:
After establishing a connection with the server, the client tells the server the key pair with which it would like to authenticate. The server checks for this key pair in its database and then sends an encrypted message to the client. The client decrypts the message with its private key and generates a hash value that is sent back to the server for verification. The server generates its own hash value and compares it with the one sent by the client. When both hash values match, the server allows the user to interact with it.

# Work
## Remote Server
Create the ssh keys
```
ssh-keygen -t ed25519
```

Create a VM on Yandex Cloud:

<img width="508" alt="Screenshot 2022-12-23 at 15 49 36" src="https://user-images.githubusercontent.com/121289219/209338988-f2a40dea-ed0d-498b-bed6-12474297c983.png">

Our public address is 158.160.35.136. Connect to it using private key
```
sudo ssh -i /Users/anatolysysoev/Desktop/ed anatolys45@158.160.35.136
```
![IMAGE 2022-12-23 16:22:05](https://user-images.githubusercontent.com/121289219/209343070-40f79e01-371a-4a3e-ad89-62043ac71c51.jpg)

Now install samtools
```
sudo apt-get update -y
sudo apt-get install -y samtools
```

Download and unpack the genome
```
wget https://ftp.ensembl.org/pub/release-108/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
wget https://ftp.ensembl.org/pub/release-108/gff3/homo_sapiens/Homo_sapiens.GRCh38.108.gff3.gz

gunzip -d Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
gunzip -d Homo_sapiens.GRCh38.108.gff3.gz
```

Indexing
```
samtools faidx Homo_sapiens.GRCh38.dna.primary_assembly.fa

sudo apt-get install -y tabix

(grep "^#" Homo_sapiens.GRCh38.108.gff3; grep -v "^#" Homo_sapiens.GRCh38.108.gff3 | sort -t"`printf '\t'`" -k1,1 -k4,4n) | bgzip > sorted.Homo_sapiens.GRCh38.108.gff3.gz

tabix -p gff sorted.Homo_sapiens.GRCh38.108.gff3.gz
```

Download the BED files
```
# Chip-seq
wget -O chip1.bed.gz "https://www.encodeproject.org/files/ENCFF874ZCC/@@download/ENCFF874ZCC.bed.gz" 
wget -O chip2.bed.gz "https://www.encodeproject.org/files/ENCFF121HYT/@@download/ENCFF121HYT.bed.gz" 
wget -O chip3.bed.gz "https://www.encodeproject.org/files/ENCFF018HXI/@@download/ENCFF018HXI.bed.gz" 

# Atac
wget -O atac.bed.gz "https://www.encodeproject.org/files/ENCFF438JMM/@@download/ENCFF438JMM.bed.gz"

# unpacking
gunzip chip1.bed.gz chip2.bed.gz chip3.bed.gz atac.bed.gz


# sorting and indexing
sudo apt install bedtools

bedtools sort -i chip1.bed > sort_chip1.bed
bedtools sort -i chip2.bed > sort_chip2.bed
bedtools sort -i chip3.bed > sort_chip3.bed
bedtools sort -i atac.bed > sort_atac.bed

bgzip sort_chip1.bed
tabix sort_chip1.bed.gz
bgzip sort_chip2.bed
tabix sort_chip2.bed.gz
bgzip sort_chip3.bed
tabix sort_chip3.bed.gz
bgzip sort_atac.bed
tabix sort_atac.bed.gz
```

## JBrowse 2

Install JBrowse and nginx
```
sudo apt install build-essential zlib1g-dev
sudo apt install nginx
sudo apt install npm
sudo apt install genometools
sudo npm install -g @jbrowse/cli
```

Create a new jbrowse repository and changing the configuraton file of nginx
```
jbrowse create /mnt/JBrowse
sudo nano /etc/nginx/nginx.conf
```

Reload nginx
```
sudo systemctl restart nginx
sudo systemctl status nginx
```

Add indexed files to JBrowser
```
sudo jbrowse add-assembly Homo_sapiens.GRCh38.dna.primary_assembly.fa --load copy --out /mnt/JBrowse
sudo jbrowse add-track sorted.Homo_sapiens.GRCh38.108.gff3.gz --load copy --out /mnt/JBrowse

sudo jbrowse add-track sort_chip1.bed.gz --load copy --out /mnt/JBrowse
sudo jbrowse add-track sort_chip2.bed.gz --load copy --out /mnt/JBrowse
sudo jbrowse add-track sort_chip3.bed.gz --load copy --out /mnt/JBrowse
sudo jbrowse add-track sort_atac.bed.gz --load copy --out /mnt/JBrowse
```

Add indexing 
```
sudo jbrowse text-index --out //mnt/JBrowse
```

http://158.160.35.136/jbrowse/
