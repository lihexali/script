git diff -z --name-only --diff-filter=ACMR tag_1.0 tag_4.0 | xargs -0 git archive 4.0 -o /tmp/testgit.zip 
