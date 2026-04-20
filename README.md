# Azure Governance Observability Platform

Enterprise-style Azure governance monitoring solution built using Azure Policy, Log Analytics, Workbooks, and Alerting.

This project demonstrates how to detect, visualize, and respond to policy violations across cloud environments using centralized observability patterns.

---

# Project Overview

This platform implements an end-to-end governance detection pipeline designed to simulate enterprise policy monitoring environments.

It enables:

- Detection of non-compliant Azure resources  
- Real-time compliance visibility  
- Automated alert generation  
- Centralized governance observability  

Scope:

```text
Management Group: mg-platform
Architecture
Management Group Policy Assignment
                │
                ▼
        Azure Policy Engine
                │
                ▼
      PolicyStates Generated
                │
                ▼
      Log Analytics Workspace
                │
                ▼
        Governance Workbook
                │
                ▼
     Scheduled Query Alert
                │
                ▼
         Action Group Trigger
                │
                ▼
        Notification Delivered
Core Components
Azure Policy Initiative

Initiative:

Cloud Governance Baseline

Purpose:

Enforce governance standards
Detect misconfigured resources
Maintain compliance posture
Log Analytics Workspace

Workspace:

law-governance-core (UK South)

Used for:

Policy evaluation logging
Compliance telemetry
KQL-based alerting
Alerting Pipeline

Alert Name:

alert-policy-noncompliance

Trigger:

Non-compliant resources detected

Configuration:

Frequency: 5 minutes
Threshold: > 0 results
Severity: Warning

Notification:

Email Action Group
Validation Results

The system was validated using deliberate policy violation testing.

Confirmed:

1.Non-compliant resource detected
2. Policy state recorded
3. Workbook updated
4. Alert triggered
5. Notification delivered


Key Skills Demonstrated

Azure Policy
Azure Monitor
Log Analytics
KQL Querying
Azure Workbooks
Alert Engineering
Governance Automation
Known Limitation

Activity-based policy assignment alerts were explored but not included in the final validated flow due to management-group scope logging behavior.

Future Enhancements
Policy remediation automation
Self-healing governance workflows
Compliance trend analytics
Multi-subscription scaling