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
    install-starship \
	install-vim-plugin \
	complete \

.PHONY: install-starship
install-starship:
	curl -sS https://starship.rs/install.sh | sh

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
.PHONY: run-test-env
 run-test-env: zip-dotfiles build-test-docker-image
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	docker rm -vf $(TEST_CONTAINER)
	docker run -itd --name $(TEST_CONTAINER) $(TEST_IMAGE)
	docker cp $(DOTFILES_ZIP) $(TEST_CONTAINER):/home/tona0516/
	docker exec $(TEST_CONTAINER) bash -c "unzip $(DOTFILES_ZIP); rm -f $(DOTFILES_ZIP)"
	docker exec -it $(TEST_CONTAINER) env TERM=xterm-256color /usr/bin/zsh

.PHONY: zip-dotfiles
zip-dotfiles:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	rm -vf $(DOTFILES_ZIP)
	zip -r $(DOTFILES_ZIP) ../$(DOTFILES_NAME) -x "*.git*"

.PHONY: build-test-docker-image
build-test-docker-image:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	docker build -t $(TEST_IMAGE) .

#----------------------------------------
# Other commands
#----------------------------------------
.PHONY: install-brew-package
install-brew-package:
	@printf "$(CYAN_BOLD)%s$(NC)\n" "$@:"
	brew bundle --file Brewfile

