


clean:
	./teardown.sh

up:
	./setup.sh

test:
	ansible -u vagrant -i inventory -m shell -a "ls -al" all
