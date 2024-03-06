# Task: Conduct a security assessment of the Docker containers used in yourorganization's environment. Perform the following tasks:

**1. Vulnerability Scanning:**

**. Use a container security scanning tool (e.g., Trivy, Clair) to scan Docker images for known vulnerabilities.**

**. Identify any high-risk vulnerabilities present in the container images.**

```
# trivy image demo --severity HIGH,CRITICAL                                                  1 ↵
2024-03-06T14:22:24.585+0700	INFO	Vulnerability scanning is enabled
2024-03-06T14:22:24.585+0700	INFO	Secret scanning is enabled
2024-03-06T14:22:24.585+0700	INFO	If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2024-03-06T14:22:24.585+0700	INFO	Please see also https://aquasecurity.github.io/trivy/v0.49/docs/scanner/secret/#recommendation for faster secret detection
2024-03-06T14:22:24.761+0700	INFO	Detected OS: centos
2024-03-06T14:22:24.761+0700	INFO	Detecting RHEL/CentOS vulnerabilities...
2024-03-06T14:22:24.823+0700	INFO	Number of language-specific files: 3
2024-03-06T14:22:24.823+0700	INFO	Detecting node-pkg vulnerabilities...
2024-03-06T14:22:24.825+0700	INFO	Detecting jar vulnerabilities...
2024-03-06T14:22:24.826+0700	INFO	Detecting python-pkg vulnerabilities...

demo (centos 7.2.1511)

Total: 210 (HIGH: 164, CRITICAL: 46)
.....................
```

*Identify any high-risk vulnerabilities present*: [Link here](https://github.com/ladung/socone-test/blob/main/soc/section5/report.html)

**2. Image Hardening:**

**Implement measures to harden the Docker images and minimize potential attack surfaces.**

**Consider best practices such as minimizing the use of unnecessary packages, enabling security features in the Docker daemon, and implementing least privilege principles**

```
FROM centos:centos7.2.1511
ARG CURL_OPTIONS="-sSL -f"

# Install essential tools
RUN yum -y install deltarpm

# Install dependencies for specific tools (minimize packages)
RUN yum -y install \
  bison \
  gnutls-devel \
  gcc \
  libidn-devel \
  gcc-c++ \
  bzip2 \
  make \
  tar \
  wget \
  java-1.8.0-openjdk \
  java-1.8.0-openjdk-headless \
  rpm-build \
  redhat-rpm-config \
  rpmdevtools

RUN curl -LO ${CURL_OPTIONS} \
      https://nodejs.org/dist/v0.10.41/node-v0.10.41-linux-x64.tar.gz && \
    tar zxf node-v0.10.41-linux-x64.tar.gz && \
    mkdir /opt/nodejs && \
    cd node-v0.10.41-linux-x64 && \
    cp -R . /opt/nodejs && \
    cd - && \
    rm -rf node-v0.10.41-linux-x64 && \
    rm -rf *.tar.gz

COPY utils.js /tmp/utils.js
COPY demo.sh /demo.sh
COPY demo.dat /

# Run demo script with least privilege (consider using a non-root user)
RUN /usr/bin/bash /demo.sh

# Exclude installed Java packages from future updates
RUN echo "exclude=java-1.8.0-openjdk java-1.8.0-openjdk-headless" >> /etc/yum.conf

# Clean up temporary files
RUN rm -rf *.rpm *.tar.gz *.bz2
```

**3. Continuous Monitoring:**

● Implement mechanisms for continuous monitoring of container security, such as runtime security scanning, anomaly detection, and logging/auditing.

● Set up alerts for detecting security incidents or suspicious activities in the container environment.
