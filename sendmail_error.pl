#!/usr/bin/perl

# we use 'strict' to help catch typos
use strict;
  use warnings;
  use Email::Send;
  use Email::Send::Gmail;
  use Email::Simple::Creator;

# 'my' is giving the varibables as small a scope as possible so that we don't 
# have to worry what they are doing elsewhere
# below we are creating a simple email from the administrator to the administrator
# it has a subject line and a body of text that will be output in the email
  my $email = Email::Simple->create(
      header => [
          From    => 'bigmarker14@gmail.com',
          To      => 'bigmarker14@gmail.com',
          Subject => 'There are problems with the site',
      ],
      body => 'Deployment ran into errors. Please check the log file.',
  );
# below we provide the necessary information to login
  my $sender = Email::Send->new(
      {   mailer      => 'Gmail',
          mailer_args => [
              username => 'bigmarker14@gmail.com',
              password => 'doo10daa',
          ]
      }
  );
  eval { $sender->send($email) };
