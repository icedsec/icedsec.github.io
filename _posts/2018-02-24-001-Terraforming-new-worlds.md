---
layout: post
title: Terraforming new worlds
date: 2018-02-24
categories: terraform
---

# Terraforming new worlds
<a href="https://www.terraform.io/">Terraform</a> is a tool by Hashicorp that allows you to create infrastructure within different cloud providers. 

This post is aimed at giving you enough information that you need to hit the ground running and begin creating infrastrucutre that can be used in order to create things such as labs or just about any other infrastrucutre that you have to manage. We will be using Terraform for the next series of posts in order to create what we will be using later on.

Please note that to follow along at home, you will need an AWS account.


## Why will we be doing this?
Using a tool such as Terraform will allow us to create automated, consistent results when standing up infrastructure. It also places our infrastructure in a format that easily lets us audit it to ensure that those crazy infrastructure folks aren't doing anything they shouldn't be (if you work on an infrastructure team, I'm sorry. You're not crazy. I am.).

In future posts I will be providing the files necessary to get your lab setup ready nice and easy with Terraform, so that is another reason that this is the first entry.  


## What is Terraform?
Let's take a quick dive into the different components of Terraform and host we can use it. 

If you haven't gathered already, Terraform is a command-line based tool that hooks in to different cloud providers and allows you to turn infrastructure into code (buzzwords - drink). It works by interpreting what's known as HCL (Hashicorp Configuration Language) that you save into `.tf` files and then using your credentials to run the appropriate API commands to create what's stored in the files. 

Before we go any further let's take a quick look at a simple `.tf` file (a config file) called `buckethead.tf` that sets up an Amazon S3 bucket for us.

```
$ cat buckethead.tf 
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "buckethead_theme_park"
  acl    = "private"

  tags {
    Name = "Bucketheadland"
  }
}
```

In this file, we're defining our provider as AWS, and then creating an S3 bucket resource.

### Terminology
It's probably a good idea to define some of these terms.

A **provider** is used by Terraform to identify what sort of resources we're about to use and API calls we're about to make.

A **resource** is the object we want Terraform to operate on. Whether that be the S3 bucket above, or something like an EC2 instance, that'd be a resource.

A Terraform **init** is what we will have to run before we can begin to plan or apply our resources to the universe. An initialization command sets everything up and ensures that we're ready to rock.

**Planning** is what will let us see exactly how Terraform will apply the resources we've defined on the specific providers. Think of this as a dry-run.

**Applying** is the real deal. When you apply, Terraform will make all of the changes you've defined. Please note that by default in our case a `terraform apply` will run with the default creds in your AWS credentials file.

Let's take a look at the basic workflow.

### Workflow
#### Installation
Before we can use Terraform, we have to download and install it. At the time of writing, the current version is 0.11.3.

I am going to be installing the Linux version. The MacOS steps shouldn't differ much from this, but if you're on Windows, you'll want to take a look at the installation guide <a href="https://www.terraform.io/intro/getting-started/install.html">here</a>.

To install Terraform, I will run the following:

```
#Downloading Terraform binary
$ wget https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip

#Extracting it
$ unzip terraform_0.11.3_linux_amd64.zip

#Moving it to a directory in my path environment variable
$ sudo mv terraform /usr/local/bin
```

If you aren't exactly sure what your path directories are, you can run something like `echo $PATH` to get a listing. Adding the Terraform binary into one of these directories will allow us to call the file from any location on the filesystem in our terminal.

You can then test your install:
```
$ terraform version

Terraform v0.11.3
```
Great. Let's move on. If you have issues, ensure that they're nice and troubleshot before moving along.

#### Terraform Init
Running a `terraform init` command is the first step we take after we've created our config file that contains the providers and resources we'd like to apply. 

This command reads config files in the current directory and ensures that providers can be loaded and that the resources are supported. This command is essentially our pre-flight checklist.

#### Terraform Plan
If the `init` acts as our pre-flight checklist, then a `terraform plan` command is a flight simulator. Running this command will take a look at the config files we have and act out any changes that will be done when we finally apply our config.

#### Terraform Apply
By now I'm sure that you can guess what this does. Running a `terraform apply` will apply the configuration that we've defined in our files. The resources will be created, updated, deleted in our providers as we have defined.


### Example: Creating an S3 bucket
Let's solidify this workflow with an example based on the config file from above. After all, Brian needs to store his music somewhere.

After creating our config file, we're going to run an init to ensure we are ready to go.
```
$ terraform init

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "aws" (1.10.0)...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 1.10"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

Once that's done, we'll now run our plan to verify the changes we have crafted.
```
$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + aws_s3_bucket.bucket
      id:                  <computed>
      acceleration_status: <computed>
      acl:                 "private"
      arn:                 <computed>
      bucket:              "buckethead_theme_park"
      bucket_domain_name:  <computed>
      force_destroy:       "false"
      hosted_zone_id:      <computed>
      region:              <computed>
      request_payer:       <computed>
      tags.%:              "1"
      tags.Name:           "Bucketheadland"
      versioning.#:        <computed>
      website_domain:      <computed>
      website_endpoint:    <computed>


Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.

```

And finally we will apply our changes.
```
$ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + aws_s3_bucket.bucket
      id:                  <computed>
      acceleration_status: <computed>
      acl:                 "private"
      arn:                 <computed>
      bucket:              "buckethead_theme_park"
      bucket_domain_name:  <computed>
      force_destroy:       "false"
      hosted_zone_id:      <computed>
      region:              <computed>
      request_payer:       <computed>
      tags.%:              "1"
      tags.Name:           "Bucketheadland"
      versioning.#:        <computed>
      website_domain:      <computed>
      website_endpoint:    <computed>


Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_s3_bucket.bucket: Creating...
  acceleration_status: "" => "<computed>"
  acl:                 "" => "private"
  arn:                 "" => "<computed>"
  bucket:              "" => "buckethead_theme_park"
  bucket_domain_name:  "" => "<computed>"
  force_destroy:       "" => "false"
  hosted_zone_id:      "" => "<computed>"
  region:              "" => "<computed>"
  request_payer:       "" => "<computed>"
  tags.%:              "" => "1"
  tags.Name:           "" => "Bucketheadland"
  versioning.#:        "" => "<computed>"
  website_domain:      "" => "<computed>"
  website_endpoint:    "" => "<computed>"
aws_s3_bucket.bucket: Creation complete after 6s (ID: buckethead_theme_park)

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

```

After this has been run, a new bucket has been created within my AWS account!

## Conclusion
This was just a very basic introduction to what Terraform is and what it can do. I hope it displayed to you what it can be used for, and got you thinking about how we can use it to create infrastructure within our providers.
Next time, we won't be focusing as much on Terraform, but the config files will get much more complicated and do things like reference variables from other resources. That's all for now. 

