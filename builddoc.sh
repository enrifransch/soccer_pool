rm -rf doc
rdoc --title="SoccerPool" \
     --main src/Home.rdoc \
     --exclude ".json|.css|.erb|.sh" \
     src
