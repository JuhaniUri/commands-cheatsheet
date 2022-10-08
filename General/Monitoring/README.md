# Monitoring

Monitoring can be divided two parts:

* Infra monitoring <br />
Usually tools like Zabbix, Prometheus, Grafana, Statuscake etc. <br />
It's quite common that basic monitoring is enabled and maintained by Infra/Ops team.

* Application monitoring <br />
Tools like Prometheus, Grafana, AppDynamics, Dynatrace etc. <br />
Is enablement comes from the developers and business side.

Good setup has a centralized logging enabled like ELK, OpenSearch etc. Logging can compliment our monitoring set.


![Monitoring](Monitoringv2.png)



# Methods for gathering metrics

In short summary:

* USE is all about RESOURCE metrics.<br />
https://www.brendangregg.com/usemethod.html<br />

* RED is about gathering SERVICE metrics.<br />
https://www.weave.works/blog/the-red-method-key-metrics-for-microservices-architecture/<br />

* The Four Golden Signals gather metrics each SERVICE + RESOURCE Saturation.<br />
https://sre.google/sre-book/monitoring-distributed-systems/<br />


![Methods-for-gathering-metrics](Methods-for-gathering-metrics.png)


Application performance monitoring (APM)
![APM](APM.png)