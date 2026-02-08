# Architecture Design

## Overview

This project implements an automated platform for provisioning and hardening Linux servers using Infrastructure-as-Code and configuration automation.

The platform integrates Terraform, Ansible, and CI/CD pipelines to deliver secure, reproducible, and compliant server deployments.

## High-Level Workflow

GitHub Actions → Terraform → Cloud VM → Ansible → Hardened Linux Server

## Components

### GitHub Actions (CI/CD)
- Infrastructure validation
- Automated provisioning
- Configuration deployment
- Continuous security enforcement

### Terraform (Infrastructure Provisioning)
- Cloud VM provisioning
- Network configuration
- SSH key injection
- Infrastructure outputs

### Ansible (Configuration Management)
- SSH hardening
- Firewall configuration
- System baseline hardening
- Patch automation

### Linux Server
- Ubuntu 22.04 LTS
- CIS-inspired security baseline

## Security Design Goals

- Minimize attack surface
- Enforce least privilege
- Prevent brute-force attacks
- Enable automatic patch management
- Ensure configuration consistency

## Diagram

GitHub → CI/CD → Terraform → VM → Ansible → Secure Linux

