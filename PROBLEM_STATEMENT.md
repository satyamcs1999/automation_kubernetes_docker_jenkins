__<h1>Problem Statement</h1>__

<ul>
  <li>Create container image that has Jenkins installed using Dockerfile or You can use the Jenkins Server on RHEL 8/7. </li>
  <li>When we launch this image, it should automatically start Jenkins service in the container. </li>
  <li>Create a Job chain of Job1, Job2 and Job3 in Jenkins. </li> 
  <li>Job1 : Pull the GitHub repo automatically when some developers push repo to GitHub. </li>
  <li>Job2 :</li> 
   <ol>
     <li>By looking at the code or program file, Jenkins should automatically start the respective language interpreter installed in image container to deploy code on top of Kubernetes.</li>
     <li>Expose your pod so that testing team could perform testing on the pod.</li>
     <li>Make the data persistent.</li>
  </ol> 
  <li>Job3 : Test your app if it is working or not. If app is not working , then send email to developer and re-deploy the application after code is being edited by the developer.</li>
</ul>
