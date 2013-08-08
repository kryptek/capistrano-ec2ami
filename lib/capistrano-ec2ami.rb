require 'fog'
require 'capistrano'

module Capistrano
  module EC2AMI

    ######################################################################
    # def extend
    #
    # Purpose: Extends the module methods to the Capistrano class
    #
    # Returns: nothing
    ######################################################################
    def self.extend(configuration)

      configuration.load do
        Capistrano::Configuration.instance.load do

          _cset(:aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY'])
          _cset(:aws_access_key_id, ENV['AWS_ACCESS_KEY_ID'])

          ######################################################################
          # def ec2
          #
          # Purpose: Creates a class variable for accessing AWS
          #
          # Returns: Fog::Compute::AWS
          ######################################################################
          def ec2
            @@ec2 = Fog::Compute::AWS.new(
              aws_secret_access_key: fetch(:aws_secret_access_key),
              aws_access_key_id: fetch(:aws_access_key_id)
            )
          end

          ######################################################################
          # def find_instance_id
          #
          # Purpose: Returns the instance ID for a particular IP address
          #
          # Returns: String
          ######################################################################
          def find_instance_id(address)
            ec2.servers.detect { |server|
              server if (server.public_ip_address == address) || (server.private_ip_address == address)
            }

          end

          ######################################################################
          # def create_ami
          #
          # Purpose: Facilitates the creation of an AMI on AWS's EC2 service
          #
          # Parameters:
          #   options<~Hash>
          #     name<~Symbol>: The name for the AMI
          #     description<~Symbol>: The description for the AMI
          #     no_reboot<~Boolean>: Whether or not to reboot the instance
          #
          # Returns: String
          ######################################################################
          def create_ami(options={})
            logger.info "\e[1;44m ## Creating AMI!\e[0m"
            instance = find_instance_id(roles[options[:role]].servers.sample.host).id

            ami_id = ec2.create_image(
              instance,
              options[:name] || "capistrano-ec2ami-#{Time.now.to_i}",
              options[:description] || "AMI of instance #{instance} created by capistrano-ec2ami (#{Time.now})",
                options[:no_reboot] || true
            )

            logger.info "\e[1;44m Successfully created AMI: #{ami_id.body['imageId']}\e[0m"
          end


        end
      end

    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::EC2AMI.extend(Capistrano::Configuration.instance)
end
