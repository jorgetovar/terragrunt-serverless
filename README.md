# How to deploy a serverless application using Terragrunt

### Why Use Terragrunt to Deploy Applications on AWS?  

There are many principles and patterns in software engineering that I've found valuable for building reliable and robust applications. Among them are well-known concepts like the Dependency Inversion Principle (DIP), the Law of Demeter (LoD), and Murphy's Law (ML). However, perhaps the easiest one for all of us to remember is **Don't Repeat Yourself (DRY)**.  

The core idea of this principle is to avoid code duplication and, even more importantly, to maintain a **single source of truth**.  

### Deploying Applications on AWS  

In my experience, I have used **CloudFormation** and **Terraform** for deploying enterprise applications on AWS. Both are excellent tools capable of handling anything from simple systems to distributed applications serving millions of users.  

By default, I prefer CloudFormation because it is AWS-native, doesn't require managing complex Terraform state files, and "just works." However, as applications grow in complexity, the advantages of using **Terraform modules** and reusing higher-level abstractions become evident, often making Terraform a better fit.  

### Managing Complexity  

As applications expand in terms of resources, dependencies, and environments, it becomes crucial to follow best practices and organize code to efficiently manage multiple resources while keeping environments secure and state isolated.  

### Typical Code Structure and Its Drawbacks  

A common approach is to create isolated folders for each environment (e.g., `prod`, `stage`, and `dev`), ideally living in separate AWS accounts and sharing nothing.  

Each environment may use different module versions, either public or stored in the same repository. While this setup offers flexibility, it introduces significant code duplication. Maintaining consistent module usage across environments requires careful manual management and version control, which becomes tedious and error-prone.  

### Terragrunt as an Alternative  

Terragrunt is a tool that acts as a wrapper for Terraform, simplifying the management of complex infrastructure. It allows developers to:  

- Reduce code duplication by using configuration (`HCL`) files to define shared resources and modules.  
- Set a single source of truth for environment configurations.  
- Maintain isolated state management for different environments.  

This approach minimizes the need for separate branches and reduces maintenance overhead, making it easier to maintain and scale infrastructure.  

### Code Example (GitHub)

For a practical demonstration, you can refer to my example project:  
[Terragrunt Serverless](https://github.com/jorgetovar/terragrunt-serverless/tree/main)  

### Explanation  

We follow a typical Terraform project structure to create our infrastructure modules while leveraging [AWS Terraform Modules](https://github.com/terraform-aws-modules).  

The key improvement introduced by **Terragrunt** is the ability to avoid code duplication across environments by centralizing configuration management. Instead of duplicating code for `dev`, `stage`, and `prod` environments, Terragrunt allows us to define reusable inputs and references, significantly simplifying maintenance.  

Below is an example structure:  

![Structure](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/fmg4gqhadxrzw8huyzmt.png)  

### Environment-Specific Folders  

We create two environment-specific folders, `stage` and `dev`, where we only define the module source and provide specific input variables:  

**stage**  
```hcl
terraform {
  source = "../../modules/lambda-api"
}

inputs = {
  lambda_description = "My awesome Lambda Function"
  environment        = "stage"
}
```  

**dev**  
```hcl
terraform {
  source = "../../modules/lambda-api"
}

inputs = {
  lambda_description = "My awesome Lambda Function"
  environment        = "dev"
}
```  

By defining just the source and input variables in environment folders, Terragrunt eliminates the need to copy and maintain separate Terraform files for each environment.  

---

### Running Terragrunt Commands  

Terragrunt uses the same commands as Terraform but streamlines multi-environment deployments.  

1. **Initialize:**  
   ```bash
   terragrunt init
   ```  
   ![Init](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jhjf9cbsh0yrhm2i2nmx.png)  

2. **Apply Configuration:**  
   ```bash
   terragrunt apply
   ```  
   ![Apply](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/41dtgmo33x6x057f273c.png)  

3. **Test the API:**  
   ```bash
   curl $(terragrunt output -raw api_gateway_v2_api_api_endpoint)
   ```  
   ![Output](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/6e7md66c5gn2u7rj83um.png)  

4. **Destroy Infrastructure:**  
   ```bash
   terragrunt destroy
   ```  
   ![Destroy](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/egsge4rx2xrx33khiy22.png)  

---

### Conclusion 🤔  

In this article, we explored how **Terragrunt** simplifies infrastructure deployment on AWS, significantly reducing code duplication by enabling modular and reusable configurations.  

By leveraging IaC and automation, we achieve faster, more reliable deployments while maintaining cleaner, maintainable code. Organizing modules thoughtfully allows us to integrate them into infrastructure without requiring an understanding of the entire system.  

If you found this useful, check out more of my work:  

- [LinkedIn](https://www.linkedin.com/in/jorgetovar-sa/)  
- [Twitter](https://twitter.com/jorgetovar621)  
- [GitHub](https://github.com/jorgetovar)  

Visit my blog at [jorgetovar.dev](https://jorgetovar.dev) for more insights.  
