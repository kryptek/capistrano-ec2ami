= capistrano-ec2ami

Create AMI's from your EC2 instances with your capistrano scripts.

## Usage

The following is a small example of how to create an AMI of a machine with role[:web]:

```
require 'capistrano-ec2ami'

create_ami({
  role: :web
  name: 'ami-name-here',
  description: 'ami-description-here',
  no_reboot: true
})

```

## Requirements
You are expected to have ENV variables for your AWS credentials
* ENV['AWS_SECRET_ACCESS_KEY']
* ENV['AWS_ACCESS_KEY_ID']

## Notes

* In my own experience, creating an AMI immediately after a deployment caused some kind of corruption in the AMI.
It may be some kind of latency issue with EBS and creating an AMI; I'm not sure. I solved the issue by
placing a 60s with `sleep 60` before creating my AMI.

* All parameters for options are optional. Capistrano-Ec2Ami will, by default, create your AMI with a name and description as
well as not reboot your instance.

== Contributing to capistrano-ec2ami
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2013 Alfred Moreno. See LICENSE.txt for
further details.

