generate:
	tuist install
	tuist generate

clean:
	rm -rf Projects/**/*.xcodeproj
	rm -rf Projects/**/Derived
	rm -rf Projects/**/**/*.xcodeproj
	rm -rf Projects/**/**/Derived
	rm -rf *.workspace
	
reset:
	tuist clean
	@if [ -e ./Tuist/Package.resolved ] ; then \
		rm Tuist/Package.resolved; \
	fi
	make clean

feature:
	@./Scripts/Module/feature_module.sh

dependency:
	@./Scripts/Module/dependency.sh
