## Lab2 - Task 3 (Jenkins CI/CD cho microservices) — dùng Git submodule

Project microservices dùng cho Task3 được add vào repo này dưới dạng **git submodule**:
- Path: `Lab2/Task3/netflix-clone-devsecops`
- Repo: `https://github.com/qht-nice/netflix-clone-devsecops.git`

### Clone đúng cách (bắt buộc có submodule)
```bash
git clone --recurse-submodules <YOUR_REPO_URL>
```

Nếu bạn đã clone rồi nhưng chưa kéo submodule:
```bash
git submodule update --init --recursive
```

### Update submodule lên commit mới nhất
```bash
git submodule update --remote --merge
git add .gitmodules Lab2/Task3/netflix-clone-devsecops
git commit -m "Update submodule netflix-clone-devsecops"
```

### Jenkins dùng folder nào?
Trong Jenkins job, trỏ pipeline tới file:
- `Lab2/Task3/netflix-clone-devsecops/Jenkinsfile`


