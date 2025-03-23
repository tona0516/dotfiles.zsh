TEST_IMAGE     := dotfiles_test_image
TEST_CONTAINER := dotfiles_test_container
DOTFILES_NAME  := dotfiles.zsh
DOTFILES_ZIP   := dotfiles.zsh.zip

GREEN     := \033[0;32m
CYAN_BOLD := \033[1;36m
NC        := \033[0m

#----------------------------------------
# Deploy commands
#----------------------------------------
.PHONY: deploy
deploy: \
	check-prerequisite \
	create-symlink \
    install-devbox \
	install-starship \
	install-vim-plugin \
	complete \

.PHONY: check-prerequisite
check-prerequisite:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	command -v zsh > /dev/null 2>&1
	command -v git > /dev/null 2>&1
	command -v curl > /dev/null 2>&1
	command -v vim > /dev/null 2>&1

.PHONY: create-symlink
create-symlink:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	./script/create_symlink.zsh

.PHONY: install-devbox
install-devbox:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	curl -L https://nixos.org/nix/install | bash
	curl -fsSL https://get.jetify.com/devbox | bash
	devbox global install

.PHONY: install-starship
install-starship:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	curl -sS https://starship.rs/install.sh | sh

.PHONY: install-vim-plugin
install-vim-plugin:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qa

.PHONY: complete
complete:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	@printf "$(GREEN)%s$(NC)\n" "$(DOTFILES_NAME) deployment is completed."
	@printf "$(GREEN)%s$(NC)\n" "Please run 'exec zsh -l'."

#----------------------------------------
# Test commands
#----------------------------------------
.PHONY: build-image
build-image:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	docker build -t $(TEST_IMAGE) .

.PHONY: run-container
run-container: build-image
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	docker rm -vf $(TEST_CONTAINER)
	docker run -itd --name $(TEST_CONTAINER) $(TEST_IMAGE)

.PHONY: exec-zsh-container
exec-zsh-container:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	docker exec -it $(TEST_CONTAINER) env TERM=xterm-256color /usr/bin/zsh

.PHONY: zip-dotfiles
zip-dotfiles:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	rm -vf $(DOTFILES_ZIP)
	cd ..; zip -r $(DOTFILES_ZIP) $(DOTFILES_NAME) -x "*.git*"
	cd ..; mv $(DOTFILES_ZIP) $(DOTFILES_NAME)

.PHONY: put-dotfiles
put-dotfiles: zip-dotfiles
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	docker cp $(DOTFILES_ZIP) $(TEST_CONTAINER):/home/tona0516/
	docker exec $(TEST_CONTAINER) bash -c "rm -r $(DOTFILES_NAME); unzip $(DOTFILES_ZIP); rm $(DOTFILES_ZIP)"

.PHONY: run-test
run-test: run-container put-dotfiles exec-zsh-container
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"

#----------------------------------------
# Other commands
#----------------------------------------
.PHONY: install-brew-package
install-brew-package:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	brew bundle --file Brewfile

