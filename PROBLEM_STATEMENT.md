__<h1>Problem Statement</h1>__

<ul>
  <li>Create container image that’s has Jenkins installed  using dockerfile  Or You can use the Jenkins Server on RHEL 8/7. </li>
  <li>When we launch this image, it should automatically starts Jenkins service in the container. </li>
  <li>Create a job chain of job1, job2 and job3 in Jenkins. </li> 
  <li>Job1 : Pull  the Github repo automatically when some developers push repo to Github. </li>
  <li>Job2 :</li> 
   <ol>
     <li>By looking at the code or program file, Jenkins should automatically start the respective language interpreter installed image container to deploy code on top of Kubernetes ( eg. If code is of  PHP, then Jenkins should start the container that has PHP already installed ).</li>
     <li>Expose your pod so that testing team could perform the testing on the pod.</li>
     <li>Make the data to remain persistent ( If server collects some data like logs, other user information).</li>
  </ol> 
  <li>Job3 : Test your app if it  is working or not. If app is not working , then send email to developer with error messages and redeploy the application after code is being edited by the developer.</li>
</ul>
