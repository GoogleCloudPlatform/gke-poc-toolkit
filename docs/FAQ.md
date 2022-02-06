# FAQ

### What is the purpose of the GKE PoC Toolkit? 

The GKE PoC Toolkit sets out to provide a set of infrastructure as code (IaC) which deploys GKE clusters with a strong security posture that can be used to step through demos, stand up a POC, and deliver a codified example that can be re-used / provide inspiration for production GKE environments. 

The maintainers of this repo need to set up GKE demos often, but since every environment was a little bit different, they needed a bunch of forked scripts, gcloud commands, and Terraform in order to do that, which is hard to maintain and re-use over time. The maintainers wanted an easier, one-click way of building GKE demos, so they compiled a bunch of Terraform modules together and wrapped it in a friendly Go CLI. This tool is open source so that anyone can explore the awesomeness of GKE!  

### What user analytics data do you collect?

The maintainers of the Toolkit collect anonymous usage statistics to understand its usage and make improvements. Data collection is **opt-in only** when you run `gkekitctl init`. See the [Analytics](/docs/analytics) doc for the list of what we collect, should you opt in to anonymous analytics.
### What kinds of things can I build with the Toolkit? 

You can build pretty much any kind of GKE / Anthos on GCP demo you want, from minimal single-cluster demos, to best-practices GKE security architectures, to large multi-cluster Anthos Service Mesh reference demos. 

Check out the [Building Demos](/docs/building-demos.md) doc to learn more.

### How can I contribute to this repo? 

We love contributions! Check out the [list of open issues](https://github.com/gke-poc-toolkit/issues) and the [contributing guide](/CONTRIBUTING.md) to get started. 
