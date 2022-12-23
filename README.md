# Theory
## 1
Docker is a software development tool and virtualization technology that makes it easier to develop, deploy, and manage applications using containers. Containing a lightweight, self-contained package of executable pieces of software containing all the libraries, configuration files, clients, and other pieces necessary for the application to run.

Unlike Docker, dependency management
1. is a way to define, resolve, and use client dependencies in an automated way as required by the project.
2. works at the source code level.
3. has a function to install the correct client in a particular application. Overall, dependency management systems are used by developers but not by users or system administrators.
4. the program inside the virtual machine cannot interfere with the operation of the host computer. Therefore, the execution of tasks such as accessing virus-infected data and testing the operating system is performed using virtual machines.

Docker vs VM:
1. Docker containers are hosted on the same physical server as the main OS. As for VMs, there is a host OS and a guest OS. VMs are isolated from the rest of the systes which makes it safer to deal with tasks that would be dangerous to perform directly in the host environment
2. Unlike Docker, VMs are self-contained with their own kernel and security features. Therefore, applications that require additional privileges and security run on a VM.
3. Unlike for Docker, there is no possibility to explore a application across platforms using VMs, because they are isolated from their OS. 
4. Docker lightweight container architecture requires fewer resources than VMs.

## 2
Pros:
1. Speed of creation. A container can be created faster than VM. 
2. Economy. The container takes up less space in the warehouse, which reduces overhead costs.
3. High productivity. The absence of inter-network dependencies and conflicts increases the productivity of development. Each container is actually a microservice that can be updated independently without having to worry about synchronization. 
4. Version management. It is possible to monitor the version of the containers, to follow the differences between them. 
5. Ability to migrate computing environments. All application and OS dependencies necessary for the application to work are encapsulated. 
6. Standardization. As a rule, containers are created based on open standards. Therefore, it is possible to work with them in most Linux, Microsoft, MacOS distributions. 
7. Safety. Containers are isolated from each other and from the underlying infrastructure. Changing/updating/deleting one container does not affect the other.

Cons:
1. High complexity. The growth of the number of containers working with the application affects the complexity of managing them. In a production environment, orchestrators should be used to work with multiple containers.
2. Often much more resources are packed into containers than are actually required. Because of this, the image grows, taking up more space on the disk.
3. Native Linux support. Docker and many other container technologies are based on Linux-containers, which makes running containers in a Windows environment not convenient, and daily use is more complicated than when working in Linux. 
4. Insufficient maturity. Technologies of containerization of applications appeared on the market relatively recently.

## 3
A Dockerfile is a text document with all commands the user could call on the command line to assemble an image.

A container consists of the operating system, user files, and metadata. Each container is created from an image, which tells Docker what is in the container, which process to run, when the container starts, and other configuration data. 

Docker image is read-only. When docker starts a container, it creates a read/write layer on top of the image in which the application can be run. Either via Docker program or via the RESTful API, the docker client tells the docker daemon to start the container. 

Docker does the following:

1. downloads the ubuntu image: docker checks for the presence of the ubuntu image on the local machine, and if not, then downloads it from Docker Hub
2. creates a container
3. initializes the file system and mounts the read-only level
4. initialize network/bridge: creates a network interface that allows docker to communicate with the host machine
5. Set IP address
6. Starts the specified process (application)
7. Processes and emits the application's output

## 4
Docker has become the standard for containers, so ususally when someone is talking about containers, they mean Docker containers. However, there are other containerization technology, such as:

1. LXC
which is not a standalone platform like Docker, but an OS-level virtualization system. It creates a separate virtual environment with its own process space and network stack, in which all containers use one instance of the OS kernel.

2. PodMan which is the default container management tool in the Fedora Linux distribution. It is similar to Docker, but it does not have a separate daemon, it is a standalone utility.

## 5
Conda is an open source, cross-platform package manager and environment management system that is language independent. It allows you to easily install different versions of binary software packages and any necessary libraries suitable for their platform. In addition, Conda allows you to switch between package versions and download and install updates from the software repository.

Unlike similar cross-platform Python-based package managers like pip, Conda can install Python. Conda deviates from pip in managing package dependencies. Conda is written in the Python programming language, but can manage projects containing code written in any language.

# Work
## Anaconda

Create and run a conda environment
```
conda create -n myenv --no-default-packages -y
conda activate myenv
conda config --add channels bioconda
```

Install all the tools. Picard v.2.27.5 could not be installed, so I install the latest available
```
conda installed fastqc=0.11.9
conda install star=2.7.10b
conda install samtools=1.16.1
conda install salmon=1.9.0
conda install bedtools=2.30.0
conda install multiqc=1.13
conda install picard=2.27.4 
```

Export and deactivate 
```
conda env export > env_sysoev.yml
conda deactivate
```

Delete the enviornment, since i don't need it, and check the yaml file
```
conda remove --name myenv --all -y
conda env create -f env_sysoev.yml
```

## Docker

1. Create the dockerfile: dockerfile.txt
2. Build and run it
```
docker build -t hw1docker .
docker run --rm -it hw1docker
```
3. Go to hodolint, make some changes, and add labels to make it more readable
```
# IMAGE
FROM ubuntu:20.04

# MAINTAINER
LABEL <anantolysys28@gmail.com>

# LIBRARIES
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update &&\
    apt-get install -y --no-install-recommends wget &&\
    apt-get install -y apt-utils &&\
    apt-get install -y apt-transport-https &&\
    apt-get install -y openjdk-11-jre-headless &&\
    apt-get install -y unzip &&\ 
    apt-get install -y python3-pip

RUN touch /.bashrc

# ADDITIONAL LIBRARIES
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip \
    && unzip fastqc_v0.11.9.zip \
    && rm fastqc_v0.11.9.zip \
    && chmod a+x FastQC/fastqc \
    && echo 'alias fastqc="/FastQC/fastqc"' >> /.bashrc

RUN wget https://github.com/alexdobin/STAR/releases/download/2.7.10b/STAR_2.7.10b.zip \
    && unzip STAR_2.7.10b.zip \
    && rm STAR_2.7.10b.zip \
    && chmod a+x STAR_2.7.10b/Linux_x86_64_static/STAR \
    && mv STAR_2.7.10b/Linux_x86_64_static/STAR /bin/STAR \
    && rm -r STAR_2.7.10b

RUN wget https://github.com/samtools/samtools/archive/refs/tags/1.16.1.zip -O ./samtools-1.16.1.zip \
    && unzip samtools-1.16.1.zip \
    && rm samtools-1.16.1.zip \
    && mv samtools-1.16.1/misc samtools \
    && rm -r samtools-1.16.1 \
    && echo 'alias samtools="/samtools/samtools.pl"' >> /.bashrc

RUN wget https://github.com/broadinstitute/picard/releases/download/2.27.5/picard.jar -O /bin/picard.jar && \
    chmod a+x /bin/picard.jar \
    && echo 'alias picard="java -jar /bin/picard.jar"' >> /.bashrc

RUN wget https://github.com/COMBINE-lab/salmon/releases/download/v1.9.0/salmon-1.9.0_linux_x86_64.tar.gz \
    && tar -zxvf salmon-1.9.0_linux_x86_64.tar.gz \
    && rm salmon-1.9.0_linux_x86_64.tar.gz \
    && chmod a+x salmon-1.9.0_linux_x86_64/bin/salmon \
    && mv salmon-1.9.0_linux_x86_64/bin/salmon /bin/salmon \
    && rm -r salmon-1.9.0_linux_x86_64 

RUN wget https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools.static.binary -O /bin/bedtools.static.binary && \
    chmod a+x /bin/bedtools.static.binary \
    && echo 'alias bedtools="/bin/bedtools.static.binary"' >> /.bashrc

RUN pip install multiqc==1.13
```


