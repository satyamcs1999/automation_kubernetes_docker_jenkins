shopt -s nullglob
file1=(/code/*.py)
file2=(/code/*.pl)
file3=(/code/*.rb)

if [ -f /root/python/dfile1 ] && [ -f /root/perl/dfile2 ] && [ -f /root/ruby/dfile3 ]
then
  mv /root/python/dfile1 /root/python/Dockerfile
  mv /root/perl/dfile2 /root/perl/Dockerfile
  mv /root/ruby/dfile3 /root/ruby/Dockerfile
else
  echo "Already Done"
fi

if ((${#file1[@]}))
then
  cp -R "$file1" /pycode
  if docker images | grep pythonc 
  then
    if docker ps -a | grep py_interpreter
    then
      echo "Container is already present"
    else
      docker run -dit -v /pycode:/root/code  --name py_interpreter pythonc:v1
    fi
  else
    docker build -t pythonc:v1  /root/python/
    if docker ps -a | grep py_interpreter
    then
      echo "Container is already present"
    else
      docker run -dit -v /pycode:/root/code --name py_interpreter pythonc:v1
    fi
  fi
fi

if ((${#file2[@]}))
then
  cp -R "$file2" /perlcode
  if docker images | grep perlc 
  then
    if docker ps -a | grep perl_interpreter
    then
      echo "Container is already present"
    else
      docker run -dit -v /perlcode:/root/code  --name perl_interpreter perlc:v1
    fi
  else
    docker build -t perlc:v1  /root/perl/
    if docker ps -a | grep perl_interpreter
    then
      echo "Container is already present"
    else
      docker run -dit -v /perlcode:/root/code --name perl_interpreter perlc:v1
    fi
  fi
fi

if ((${#file3[@]}))
then
  cp -R "$file3" /rubycode
  if docker images | grep rubyc 
  then
    if docker ps -a | grep ruby_interpreter
    then
      echo "Container is already present"
    else
      docker run -dit -v /rubycode:/root/code  --name ruby_interpreter rubyc:v1
    fi
  else
    docker build -t rubyc:v1  /root/ruby/
    if docker ps -a | grep ruby_interpreter
    then
      echo "Container is already present"
    else
      docker run -dit -v /rubycode:/root/code --name ruby_interpreter rubyc:v1
    fi
  fi
fi