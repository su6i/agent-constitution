# Contributing to Agent Constitution

[Back to README](README.md)

Thank you for your interest in contributing to the Agent Constitution! This document provides guidelines for contributing to this repository.

---

## 📋 Table of Contents
- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Skill File Structure](#skill-file-structure)
- [Workflow Guidelines](#workflow-guidelines)
- [Pull Request Process](#pull-request-process)

---

## Code of Conduct

- Be respectful and constructive in all interactions.
- Focus on technical excellence over marketing language.
- Prioritize clarity and precision in documentation.

---

## How to Contribute

### 1. Reporting Issues
- Use GitHub Issues for bug reports and feature requests.
- Provide clear reproduction steps for bugs.
- Include relevant file paths and error messages.

### 2. Proposing Changes
- Fork the repository.
- Create a feature branch: `git checkout -b feature/your-feature-name`
- Make your changes following the guidelines below.
- Submit a Pull Request.

---

## Skill File Structure

All skill files in `.cursor/skills/` must follow this structure:

```yaml
---
name: skill-name-kebab-case
description: One-line technical description of the skill.
---

# Skill: Skill Title

[Back to README](README.md)

## 1. Section Title
Content with technical depth...

---
[Back to README](README.md)
```

### Requirements:
- **Minimum 400 lines** for extreme-density encyclopedic skills.
- **No promotional language** (avoid "Revolutionary", "Cutting-edge", etc.).
- **Navigation links** at top and bottom.
- **YAML frontmatter** with `name` and `description` fields.

---

## Workflow Guidelines

Workflow files in `.cursor/workflows/` must:
- Have a clear `description` in YAML frontmatter.
- Include step-by-step instructions.
- Reference relevant prompts and skills.
- Include navigation links.

---

## Pull Request Process

1. **Title**: Use conventional commits format:
   - `feat: add new skill for X`
   - `fix: correct link in workflow`
   - `docs: update README navigation`

2. **Description**: Explain what changes were made and why.

3. **Checklist**:
   - [ ] All links are valid (run `bin/validate-links.sh`).
   - [ ] New skills meet 400+ line requirement.
   - [ ] Navigation links are present.
   - [ ] No promotional language.

4. **Review**: Wait for maintainer review before merging.

---

## Questions?

Open an issue with the `question` label or reach out via [LinkedIn](https://linkedin.com/in/su6i).

---
[Back to README](README.md)
