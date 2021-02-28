__<h1>Automation using Kubernetes, Docker, Jenkins, GitHub and Python</h1>__

![Kubernetes_Docker_Jenkins](https://miro.medium.com/max/875/1*dM0FbKDmLq8uxb8PxAa0iw.jpeg)<br>

<br>
<h2> What is this README about ?? </h2>
<p>In short , this README describes the way through which <b>Jenkins</b> and <b>Docker</b> could be set up inside a <b>Kubernetes</b> pod, and how pipeline could be setup inside the pod using Jenkins, Docker and GitHub . So let’s get started!!</p><br>

<h2>Part 1 : Creating a Dockerfile</h2>

<p>First , for building an image which could be used to setup a Kubernetes pod , Dockerfile has been created.</p><br>

```dockerfile
FROM centos

RUN yum install wget -y

RUN yum install curl -y

RUN wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

RUN rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

RUN yum install jenkins -y

RUN yum install java-11-openjdk.x86_64 -y

RUN yum install git -y

RUN yum install python3 -y

CMD mkdir /root/python

CMD mkdir /root/perl

CMD mkdir /root/ruby

COPY docker.repo  /etc/yum.repos.d/ 

RUN yum install docker-ce  --nobest -y

CMD killall firewalld

CMD /usr/bin/dockerd

CMD java -jar /usr/lib/jenkins/jenkins.war

COPY dfile1  /root/python/

COPY dfile2  /root/perl/

COPY dfile3  /root/ruby/

CMD mkdir /pycode

CMD mkdir /perlcode

CMD mkdir /rubycode

CMD mkdir /code
```

<p>Using this Dockerfile, the image created would setup Docker, Jenkins , Git and Python inside the Kubernetes pod.</p>
<p>Along with the above setup, code directory has been created which would store the code pushed in GitHub repo.</p>
<p>There are three more dockerfile named <b>dfile1</b>, <b>dfile2</b> and <b>dfile3</b> which would be used for creating container with installed interpreter of <b>Python</b>, <b>Perl</b> and <b>Ruby</b> respectively inside the pod.</p>
<p>Three more directories namely pycode , perlcode and rubycode has been created which would store respective language code , from the code directory created above, the code of the respective language file based on their extension would be pushed to the respective directory i.e. <b>pycode</b>, <b>perlcode</b> or <b>rubycode</b>.</p>
<p><b>“docker build -t <your image name along with version> <location from / where Dockerfile is present>”</b> is used for creating image from Dockerfile.</p>

<br>
<p align="center"><b>. . .</b></p><br>

<h2>Part 2 : Setting up Kubernetes Deployment using YAML</h2>

<p>In this part , we setup our Deployment in Kubernetes using YAML as follows :</p><br>

```yaml
apiVersion: v1
kind: Service
metadata:
  name: jenkins-deployment
  labels:
    app: jenkins
spec:
  type: NodePort
  selector:
    app: jenkins
  ports:
  - protocol: TCP        
    port: 80
    targetPort: 8080
    nodePort: 30030
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pv-claim-task
  labels:
    app: jenkins
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-task
spec:
  capacity:
    storage: 3Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /var/lib/minikube
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-deployment
  labels:
    app: jenkins
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      containers:
        - name: jenkins
          image: satyams1999/task3_jen_doc:v1
          ports:
          - containerPort: 8080
          imagePullPolicy: Always
          env:
          - name: POD_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
          - name: DOCKER_HOST
            value: tcp://localhost:2375
        - name: dind
          image: docker:18.05-dind
          securityContext:
            privileged: true
          volumeMounts:
            - name: dind-storage
              mountPath: /var/lib/docker
      volumes:
      - name: dind-storage
        persistentVolumeClaim:
          claimName: pv-claim-task
      nodeSelector:
        kubernetes.io/hostname: minikube
```

<p>In the above YAML file , <b>Deployment</b> has been generated under which we use two images namely <b>satyams1999/task3_jen_doc:v1</b> (created using the Dockerfile mentioned above, renamed and pushed to <b>DockerHub</b> from where the image is being pulled) and <b>docker:18.05-dind</b> (that enables usage of Docker inside the pod using the concept of <b>Docker inside Docker</b>).</p>
<p>Service is used for exposing the pod using the type <b>NodePort</b> on port 30030 and the protocol used is TCP and thereby Pod testing can be performed easily.</p>
<p><b>PVC(Persistent Volume Claim)</b> has been created that is used for claiming Persistent volume by pod so as to prevent loss of data in case pod gets terminated and the point from which Persistent Volume is claimed also known as <b>PV(Persistent Volume)</b> of size 3GiB has been specified and it obtains storage from <b>Local Storage.</b></p>
<p><b>kubectl create -f <filename.yml></b> is used for setting up deployments.</p>

<br>
<p align="center"><b>. . .</b></p><br>

<h2>Part 3 : Setting up Jenkins inside the Pod</h2>

<p>In this case , Jenkins could be accessed using :</p><br>
<p><b>http://_minikube ip_:_nodePort specified_</b></p><br>
<p>As soon as the Jenkins is accessed using the address in the format specified above, this page would appear.</p>

![Jenkins_Setup_1](https://miro.medium.com/max/875/1*togI-6sq09k0JOSsvOCGqg.png)

<br>
<p>There are two ways in which you could get your <b>initialAdminPassword</b> required for accessing Jenkins</p>
<ol>
  <li><b>kubectl logs -f _pod name_</b>, which would open the log file of the specified pod where the initialAdminPassword would be specified as well.</li>
  <li><b>kubectl exec -it _pod name_ -- bash</b> which would open a bash shell for the specified pod, under that using the path mentioned in the image , you could obtain the initialAdminPassword.</li>
</ol>

<p>After specifying the password, then click on Continue.</p>

![Jenkins_Setup_2](https://miro.medium.com/max/875/1*V4jS3QootI-wUheaoZzVlw.png)

<br>
<p><b>“Install suggested plugins”</b> installs the most useful plugins in Jenkins and for additional plugin , <b>“Select plugins to install”</b> could be selected , in this case , I select Select plugins to install.</p>

<p>After selecting Select plugins to install.</p>

![Jenkins_Setup_3](https://miro.medium.com/max/875/1*l62WC5eOKHwO39nO2ISV2A.png)

<br>
<p>Here , I have selected GitHub plugin to be installed as well along with the plugins selected by default. Click on Install.</p>
<p>After installation is completed, it asks you to setup <b>Admin User</b> , or you can select Skip and continue as admin.</p>

![Jenkins_Setup_4](https://miro.medium.com/max/875/1*FGLKrfCHc_kcdAuJyrZNYQ.png)

<br>
<p>After clicking on Save and Continue , it would ask you to setup your instance.</p>

![Jenkins_Setup_5](https://miro.medium.com/max/875/1*vZVPn2orpJCR8CGP3uXA6g.png)

<br>
<p>It basically makes the URL permanent for accessing Jenkins , after clicking Save and Finish, your account has been setup , and it would show Jenkins Home Page as</p>

![Jenkins_Setup_6](https://miro.medium.com/max/875/1*C39WMwNc1v9i1Cl-sXroTw.png)

<br>
<p align="center"><b>. . .</b></p><br>

<h2>Part 4 : GitHub Setup</h2>
<p>In this job, the developer pushes the code into GitHub.</p>
<p>Initially , we have to set up our local repository in our respective local machine and it could be set up using <b>Git Bash</b>, in our case , we have set up folder named <b>“docker_jenkins_kubernetes”</b> holding the program files. The commands to set up the same are as follows :</p>

```shell
mkdir docker_jenkins_kubernetes/

cd docker_jenkins_kubernetes/

vim merge_sort.py    # you can use notepad or any other text editor
```

<br>
<p>Before creating our own local repository , we first need to create an empty repository in GitHub , after creating , convert the existing directory i.e,<b>docker_jenkins_kubernetes</b> and push the program file “merge_sort.py” to the GitHub Repository using the following commands :</p>

```shell
git init                                

git add * 

git commit -m "Python Program"

git remote add origin https://github.com/satyamcs1999/devops_task3.git

git push -u origin master 
```

<br>
<p>For pushing the program files to our master branch in GitHub repository , we need to specify <b>“git push -u origin master</b>(only during first time) or <b>git push</b>”, but by using the the <b>hooks/</b> directory within <b>.git/</b>, we can modify it in such a way that it would commit and also push without specifying any separate command for the same, first of all we need to create a file named <b>“post-commit”,</b> and script to be included are as follows :</p>

```shell
vim post-commit

#!/bin/bash

git push
```

<br>
<p>Similarly , addition of <b>Perl</b> and <b>Ruby</b> program file has been done.</p>
<p>After this setup , GitHub would look like this:</p>

![GitHub](https://miro.medium.com/max/875/1*eAnHmvjo7W01OBSvfACZNw.png)

<br>
<p align="center"><b>. . .</b></p><br>

<h2>Part 5 : Jenkins Job</h2>

<p><b>Job 1</b> : This job first pulls the code as soon as Jenkins detect changes in connected GitHub repo.</p>

![Jenkins_Job_1](https://miro.medium.com/max/875/1*UQxvp898RZ9pTk363b4TBQ.png)

![Jenkins_Job_2](https://miro.medium.com/max/875/1*LQ2w_d-RfGpPImw_0fmMbA.png)

<br>
<p>The triggers we use are GitHub hook triggers that could be setup by adding a webhook to our GitHub repo , and for creating webhook in our repo , we need a public URL that could be generated by using <b>ngrok</b>, which uses the concept of <b>Tunneling</b>.</p><br>

```shell
./ngrok http 8080
```

<br>

![ngrok](https://miro.medium.com/max/875/1*lHHWjpUEkiMzOku_Xo_amQ.png)

<p align="center"><b>Setting up Public URL using ngrok</b></p><br><br>

![webhook](https://miro.medium.com/max/875/1*bX67d4-VfI74yllkjECLLg.png)

<p align="center"><b>Addition of Webhook</b></p><br><br>

<p>The code in this Job copies the program files inside the directory named code.</p>

![Job1_Code](https://miro.medium.com/max/875/1*KEKHfmM7bA9v7gJrBBJoyw.png)

<br><br>
<p><b>Job 2</b> : This job detects the presence of programming language used in the file based on its extension, in our case , I have considered three of them namely Python, Perl and Ruby and it’s a <b>downstream</b> project of <b>Job 1</b> and <b>upstream</b> project for <b>Job 3</b>.</p>

![Job2_Code_1](https://miro.medium.com/max/875/1*5TRYm32F782KCrMln9NDFA.png)

![Job2_Code_2](https://miro.medium.com/max/875/1*4Pr6xPBMVjAoZHyaGkUDkQ.png)

![Job2_Code_3](https://miro.medium.com/max/875/1*lklyuzKyJ_At14PC8P2h7Q.png)

<p>The above specified code for <b>Job 2</b> checks the presence of file with a particular extension from the code directory which stores the code present in GitHub repo, and then as per the extension , it copies the file to the respective directories (i.e., <b>pycode</b>, <b>perlcode</b> and <b>rubycode</b>).</p>
<p>But before the following process , it renames the Dockerfile namely <b>dfile1</b>(for Python image), <b>dfile2</b>(for Perl) and <b>dfile3</b>(for Ruby) present in different directories to Dockerfile for building image using docker build command.</p>
<p>After the code has been copied to respective directories , it checks if the image already exist, it also checks if the container already exists or not , similar thing it does in case image doesn’t exist , here additionally it creates the image from Dockerfile and then checks for container’s presence.</p>

```dockerfile
FROM centos

RUN yum install python3 -y
```

```dockerfile
FROM centos

RUN yum install perl -y
```

```dockerfile
FROM centos

RUN yum install ruby -y
```

<br><br>
<p><b>Job 3</b> : This Job’s primary goal is used to check if container containing interpreter is launched when a code is added of the same language and if not it sends an email to the developer notifying about the same and it is a downstream project of <b>Job 2</b></p>

![Job3_Code_1](https://miro.medium.com/max/875/1*qrGHQqEpi8NKu8449KGk9g.png)

![Job3_Code_2](https://miro.medium.com/max/875/1*lyojU0CPZpYUdXOQLpVL6A.png)

![Job3_Code_3](https://miro.medium.com/max/875/1*Eg0dNa_5avpVFe-ckbSrbw.png)

<p>Here, we use <b>Python script</b> for sending an <b>email</b> if the container’s launch fails</p>

![Email](https://miro.medium.com/max/875/1*rERHP7SYfpt9OHjh0jSdcw.png)

<br>
<p align="center"><b>. . .</b></p><br>
<h2>[Update]:</h2>
<p>In GitHub, master branch has been renamed to main branch, therefore before pushing the code to the GitHub repository, branch could be switched from master to main using the command mentioned below:</p><br>

```shell
git branch -M main
```

<br>
<p align="center"><b>. . .</b></p><br>

<h2>Thank You :smiley:<h2>
<h3>LinkedIn Profile</h3>
https://www.linkedin.com/in/satyam-singh-95a266182

<h3>Link to the repository mentioned above</h3>
https://github.com/satyamcs1999/devops_task3.git




