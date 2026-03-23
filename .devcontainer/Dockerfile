FROM crystallang/crystal:1.19.1

# Install dependencies and GitHub CLI
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install -y gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code via official native binary
RUN curl -fsSL https://claude.ai/install.sh -o /tmp/install-claude.sh \
    && bash /tmp/install-claude.sh < /dev/null \
    && rm /tmp/install-claude.sh \
    && ln -sf /root/.local/bin/claude /usr/local/bin/claude \
    && truncate -s 0 /root/.bashrc /root/.bash_profile /root/.profile 2>/dev/null || true

ENV PATH="/root/.local/bin:${PATH}"

# Install shards (Crystal package manager) dependencies are handled per-project
