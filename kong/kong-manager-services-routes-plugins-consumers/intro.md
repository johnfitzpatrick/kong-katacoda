
Nothing to see here. Move along....

<!-- # Intro

Kong core entities are Services, Routes, Plugins and Consumers.  



Services

One of the first configurations to allow for access to our API is to configure Service. A Service is the name Kong uses to refer to the upstream APIs and microservices it manages.

Routes

For the service to be accessible, you'll need to add a Route to it. Routes specify how (and if) requests are sent to their Services after they reach Kong. A single Service can have many Routes.

Plugins

Plugins provide a modular system for modifying and controlling Kong's capabilities. For example, to secure your API, you could require an access key. Plugins provide a wide array of functionality, including access control, caching, rate limiting, logging, and more.

Consumers

Consumers represent end users of your API. For example, once you've added the Key Authentication plugin above, you'll need to create a consumer and associated credentials. Consumers allow you to control who can access your APIs. They also allow you report on consumer traffic using logging plugins and Kong Vitals.



Learning Lab

In this learning lab, you will enable and configure these entities in Kong Manager to:

1. Forward requests through Kong to a Microservice (API)

2. Protect the Microservice with a Kong Authentication plugin (key-auth) -->
