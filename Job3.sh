if [ -f /pycode/*.py ] && docker ps -a | grep py_interpreter ;
then
  echo "Working : Python"
elif [ -f /pycode/*.py ] && ! docker ps -a | grep py_interpreter ;
then
cat << EOF > pyscript.py
#!/usr/bin/python
import smtplib, ssl
port = 587 # for starttls
smtp_server = "smtp.gmail.com"
sender_email = "<Enter sender's email address>"
receiver_email = "<Enter receiver's email address>"
password = "<Enter sender's password>"
message = """\
Subject: App Status

App is not working"""

context = ssl.create_default_context()
with smtplib.SMTP(smtp_server, port) as server:
  server.ehlo()
  server.starttls(context=context)
  server.ehlo()
  server.login(sender_email, password)
  server.sendmail(sender_email, receiver_email, message)

EOF
chmod 755 pyscript.py
python3 ./pyscript.py
fi

if [ -f /perlcode/*.pl ] && docker ps -a | grep perl_interpreter ;
then
  echo "Working : Perl"
elif [ -f /perlcode/*.pl ] && ! docker ps -a | grep perl_interpreter ;
then
cat << EOF > pyscript.py
#!/usr/bin/python
import smtplib, ssl
port = 587 # for starttls
smtp_server = "smtp.gmail.com"
sender_email = "<Enter sender's email address>"
receiver_email = "<Enter receiver's email address>"
password = "<Enter sender's password>"
message = """\
Subject: App Status

App is not working"""

context = ssl.create_default_context()
with smtplib.SMTP(smtp_server, port) as server:
  server.ehlo()
  server.starttls(context=context)
  server.ehlo()
  server.login(sender_email, password)
  server.sendmail(sender_email, receiver_email, message)

EOF
chmod 755 pyscript.py
python3 ./pyscript.py
fi

if [ -f /rubycode/*.rb ] && docker ps -a | grep ruby_interpreter ;
then
  echo "Working : Ruby"
elif [ -f /rubycode/*.rb ] && ! docker ps -a | grep ruby_interpreter ;
then
cat << EOF > pyscript.py
#!/usr/bin/python
import smtplib, ssl
port = 587 # for starttls
smtp_server = "smtp.gmail.com"
sender_email = "<Enter sender's email address>"
receiver_email = "<Enter receiver's email address>"
password = "<Enter sender's password>"
message = """\
Subject: App Status

App is not working"""

context = ssl.create_default_context()
with smtplib.SMTP(smtp_server, port) as server:
  server.ehlo()
  server.starttls(context=context)
  server.ehlo()
  server.login(sender_email, password)
  server.sendmail(sender_email, receiver_email, message)

EOF
chmod 755 pyscript.py
python3 ./pyscript.py
fi
