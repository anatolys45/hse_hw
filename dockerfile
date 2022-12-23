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