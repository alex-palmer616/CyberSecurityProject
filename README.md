## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![/CyberSecurityProject/Diagrams/](https://github.com/alex-palmer616/CyberSecurityProject/blob/main/Diagrams/network-diagram.JPG)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the filebeat-playbook.yml or metricbeat-playbook.yml file may be used to install only Filebeat or Metricbeat.

- ![metricbeat-playbook.yml](CyberSecurityProject/ansible/metricbeat-playbook.yml)
- ![filebeat-playbook.yml](CyberSecurityProject/ansible/filebeat-playbook.yml)

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly redundant, in addition to restricting access to the network.
- Load balancers allow the DVWA machines to be accessible from outside connections, while only allowing SSH connections through the jumpbox, therefor changes cannot be directly made to the DVWA containers from the internet. You must SSH into the Jumpbox, attach into the ansible shell, and then SSH from the jumpbox to the DVWA containers.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the network and system logs.
- Filebeat collects, processes, and creates an easily searchable database from the systemlogs that it installed on. From the Kibana Dashboard, you can create and apply custom filters to show exactly what you are looking for when you need it.
- Metricbeat records and the creates systemlogs on various system statistics such as CPU usage, or inbound traffic. You can create custom filters to log specific statistic that you need. 

The configuration details of each machine may be found below.

| Name       | Function       | IP Address | Operating System |
|------------|----------------|------------|------------------|
| JumpBox1   | Gateway        | 10.0.0.4   | Linux            |
| Web-1      | DVWA Container | 10.0.0.5   | Linux            |
| Web-2      | DVWA Container | 10.0.0.6   | Linux            |
| Web-3      | DVWA Container | 10.0.0.7   | Linux            |
| ELK-Server | ELK Stack      | 10.1.0.4   | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jumpbox machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- My Privite IP Address

Machines within the network can only be accessed by JumpBox1.
-The machine JumpBox1 is the only machine that can access the ELK-Server machine via SSH. As the ELK-Server machine collects and stores the systemlogs from the DWVA 
containers, I would not advise allowing machines outside of the VirtualNetwork1-Virt1-ELK network to accses the raw systemlogs. 

A summary of the access policies in place can be found in the table below.

| Name       | Publicly Accessible       | Allowed IP Addresses                                   |
|------------|---------------------------|--------------------------------------------------------|
| Jumpbox1   | No (SSH)                  | My Private IP address (SSH only)                       |
| Web-1      | No                        | 10.0.0.4 (Jumpbox1)                                    |
| Web-2      | No                        | 10.0.0.4 (Jumpbox1)                                    |
| Web-3      | No                        | 10.0.0.4 (Jumpbox1)                                    |
| ELK-SERVER | No (Kibana via port 5601) | My Private IP (HTTP via p5601) and 10.0.0.4 (SSH only) |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because it allows you to configure 
as many machines as you need with the exact same configuration without having to repeat the installation

The playbook implements the following tasks:
- Using Ansible's `apt` module, `docker.io` and `pip`(Python Installer Package) are installed
- Using Ansibles `pip` module, `docker.io`'s Python module is installed
- Using Ansibles `sysctl` module, increase the virtual memory allocated to ELK, allowing it to run properly
- Using Ansibles `docker_container` module, a docker container image containing ELK is downloaded and installed, and configure the ELK containers published ports to `5601:5601` `9200:9200` and `5044:5044`
- Using Ansibles `systemd` module, enable Docker to start on boot

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.
You can also verify ELK is running by connecting to `https://*your.elk.server.ip*:9200/app/kibania`

![/CyberSecurityProject/Diagrams/docker_ps_output.jpg](https://github.com/alex-palmer616/CyberSecurityProject/blob/main/Diagrams/docker_ps_output.JPG)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- 10.0.0.5(Web-1)
- 10.0.0.6(Web-2)
- 10.0.0.7(Web-3)

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- With Filebeat we can generate a searchable, filterable database from systemlogs from the machines ELK monitors. Metricbeat allows us to query specific system information such as memory usage or inbound packets. With both of those combined 
with Kibana, we are presented with a interactive and live graphical display to let you monitor the things that you specify.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the [filebeat-config.yml](/CyberSecurityProject/ansible/filebeat-config.yml) or [metricbeat-config.yml](/CyberSecurityProject/ansible/metricbeat-config.yml) to `/etc/filebeat/` or `/etc/metricbeat/` respectivly
- Update the hosts file to create a new group with the IP addresses of the machines you want the playbook to run
  - You can also add new IP addresses to an already existing group to run the playbook on newly added machines
- Run the playbook, and navigate to the Filebeat installation page on the ELK server GUI(`https://*your.elk.server.ip*:9200/app/kibania`), make sure your playbook completed steps 1-4 on that page, and on step 5 click `Check Data`
