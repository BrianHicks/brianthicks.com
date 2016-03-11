---
title: It All Comes Down to APIs
date: "2016-03-11T09:08:40-06:00"

---

When it comes to cluster managers, Kubernetes is currently winning among developers. Like a lot of tooling, this comes down to Kubernetes having a great API. Why "great"?

<!--more-->

**Kubernetes' has a discoverable API.** 

You have an API server, that's your one entrypoint into the system. As a developer, if I have to learn one API instead of three, that's a huge win.

**You can use Kubernetes' API piecemeal**

Do you just want to schedule pods? There's an endpoint. Do you want to schedule and keep alive a group of pods? That too. Same with load balancing, services, and the rest of the Kubernetes components.

**You can actually ​*do*​ things with Kubernetes' API right away.**

`kubectl` makes getting your feet wet super easy, and *everyone* uses it. Most of the time, you don't have to think about things like authentication or authorization.

Now let's think through these points through another product we're just getting over the hype curve with: Docker.

**Docker has a discoverable API.**

Think about `docker run you/your-image:latest` or `docker ps`. When you want to interact with Docker, what do you use? Nearly always the `docker` CLI. It's the standard entrypoint into the system.

**You can use Docker's API piecemeal**

This is more true of more recent releases, but even at the beginning you could ignore volumes and networking if your container didn't need those things.

**You can actually *do* things with Docker's API right away.**

Docker starts with an extremely shallow learning curve. The tutorial explains what the basic components are and why you want the, then drops you into the whalesay image, and adds a little at a time from there.
   
Now a caveat: these two products also both have great documentation and better marketing than the competition, and luck always plays a role in which tools get traction. That said, both their developer-facing interfaces start from the point of "how can we make life easier for our users?" rather than "what is, technically, the easiest thing to implement?" This results in people using and learning the systems, and telling their coworkers and acquaintances about them. New products could do a lot worse than to follow that example. 
