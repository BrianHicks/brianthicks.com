---
title: "Introducing terraform.py"
slug: "introducing-terraform-py"
date: "2015-06-04T10:08:00-06:00"

---
TL;DR: we've released
[`terraform.py`](https://github.com/ciscocloud/terraform.py), an Ansible dynamic
inventory for working with hosts that Terraform provisions. Read on for why:

Say you're working on an Ansible-based project (like
[I am](https://github.com/CiscoCloud/microservices-infrastructure).) You've got
everything running smoothly in Vagrant, and now you want to add support for a
cloud provider or two. [Terraform](https://www.terraform.io) is a great solution
to that problem, as
[we've documented](https://microservices-infrastructure.readthedocs.org/en/latest/getting_started/index.html#provisioning-cloud-hosts),
but then you have to find and support dynamic inventory providers for each of
those clouds, which means supporting more vendored scripts. Not only that, but
you have to be aware of the fact that most people trying your software won't be
trying it in a *brand new* environment, but will add servers in an account they
already control. Most of the current inventory providers assume that they're
controlling all the servers they can see, so this becomes a problem pretty
quickly. On top of *that*, all the dynamic inventory providers have to have your
cloud credentials and make remote calls so they tend to be, we'll say, "slow".
They also require additional software, requiring your users to have a specific
software stack.

<!--more-->


It'd be nice if there was a dynamic inventory script that:

 - used only the packages you already have on the system
 - only provisioned the hosts you care about
 - didn't talk over the network to get the host state
 - did all this in a single script.
 
That'd be cool, right?

Well, bad news: I couldn't find one. And like I said, we needed it! Only one
thing for that, then… break out the code! So, here it is:
[`terraform.py`](https://github.com/ciscocloud/terraform.py).

`terraform.py` uses the `.tfstate` files that Terraform leaves lying around on
your hard drive. It turns out that these are just JSON and contain all the
information that Terraform knows about the hosts. The script will scan the
working directory for these files, and parse any it finds into information that
Ansible can use to provision the hosts. You can see how we use this information
in the
[sample Terraform playbook in microservices-infrastructure](https://github.com/CiscoCloud/microservices-infrastructure/blob/master/terraform.sample.yml).
So this means:

 - your users don't have to install anything outside of Python (which they
   already have, if they're using Ansible)
 - you don't have to connect to a metadata service - it's all already on your
   computer
 - since we're using Terraform's state, you only touch the hosts that you
   *actually care about*. In fact, you can run multiple clusters in the same
   cloud/account that never touch each other.

And you see those roles in the sample playbook? You can add your own by adding
"role=your_role" in whatever metadata the hosts on your cloud provider support.
`terraform.py` will parse them and provide you with those groups automatically.

[![excited rabbit GIF](http://media.giphy.com/media/q5iwtmYTOjs7S/giphy.gif)](http://giphy.com/gifs/excited-bunny-squee-q5iwtmYTOjs7S)

So go read the
[terraform.py README](https://github.com/ciscocloud/terraform.py), see
[how we're using it in microservices-infrastructure](http://microservices-infrastructure.readthedocs.org/en/latest/getting_started/index.html),
and go do something cool with it!
