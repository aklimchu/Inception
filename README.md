# 🐳 Inception

---

## 📌 Introduction 
Inception is a project that introduces the fundamentals of system administration and Docker. I virtualized a full infrastructure using Docker Compose, building multiple services from scratch and orchestrating them with containers.

---

## 📚 Topics Covered

- Docker & Docker Compose
- Multi-container architecture
- SSL with NGINX
- WordPress & MariaDB configuration
- System configuration and automation
- Service orchestration & volume management

---

## 📂 Project Structure
```bash
Inception/
├── srcs/
│   ├── requirements/
│   │   ├── bonus/
│   │   └── mandatory/
│   ├── .env
│   ├── Makefile
│   └── docker-compose.yml
├── README.md
```

## 🛠️ Services Built

| 🧱 Service  | Description                        |
|------------|------------------------------------|
| **NGINX**  | Web server with SSL support        |
| **WordPress** | CMS running on PHP-FPM         |
| **MariaDB** | Relational database for WordPress |

---

## ⚙️ How to Run
| Prerequisites: Docker & Docker Compose installed on your machine.
```bash
make
```
To stop and clean up:
```bash
make clean
```
