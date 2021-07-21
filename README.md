# missing-semester
My Exercise Solutions for [The Missing Semester of Your CS Education, Winter 2020](https://missing.csail.mit.edu/2020/).

<details>
<summary>Course overview + the shell</summary>

1.
   ```
   $ echo $SHELL
   /bin/bash
   ```
2.
   ```
   $ mkdir /tmp/missing
   ```
3.
   ```
   $ man touch
   ```
4.
   ```
   $ touch /tmp/missing/semester
   ```
5.
   ```
   $ echo '#!/bin/sh' > /tmp/missing/semester
   $ echo 'curl --head --silent https://missing.csail.mit.edu' >> /tmp/missing/semester
   ```
6.
   ```
   $ /tmp/missing/semester
   -bash: /tmp/missing/semester: Permission denied
   $ ls -l /tmp/missing/semester
   -rw-r--r--  1 kumatheworld  wheel  61 Jun 30 19:20 /tmp/missing/semester
   ```
7. This works because it only needs the read permission unlike the previous one that needs the execute permission.
   ```
   $ sh /tmp/missing/semester
   HTTP/2 200
   server: GitHub.com
   content-type: text/html; charset=utf-8
   last-modified: Sat, 26 Jun 2021 10:14:39 GMT
   access-control-allow-origin: *
   etag: "60d6fe0f-1f31"
   expires: Sat, 26 Jun 2021 18:02:11 GMT
   cache-control: max-age=600
   x-proxy-cache: MISS
   x-github-request-id: E25A:3CCC:1CEDC6:1F2376:60D7694B
   accept-ranges: bytes
   date: Wed, 30 Jun 2021 10:29:43 GMT
   via: 1.1 varnish
   age: 385
   x-served-by: cache-hnd18744-HND
   x-cache: HIT
   x-cache-hits: 1
   x-timer: S1625048984.682678,VS0,VE1
   vary: Accept-Encoding
   x-fastly-request-id: af16a01b69ff7c7a566e819ede35ff74bfc59970
   content-length: 7985
   ```
8.
   ```
   $ man chmod
   ```
9. The first line of `/tmp/missing/semester` right after the shebang `#!` tells the shell what program to run. In our case, that is `/bin/sh`.
   ```
   $ chmod u+x /tmp/missing/semester
   $ /tmp/missing/semester
   (command output shown)
   ```
0.
   ```
   $ /tmp/missing/semester | grep "last-modified" > ~/last-modified.txt
   ```
</details>

<details>
<summary>Shell Tools and Scripting</summary>

1. The following command lists the files under `$dir` in that way.
   ```
   $ ls -alhtG "$dir"
   ```
2.
   ```
   marco() {
      export MARCO=$(pwd)
   }

   polo() {
      cd "$MARCO"
   }
   ```
3. Assuming the given script is named `magic.sh`, the following script is what we want.
   ```
   #!/usr/bin/env bash

   file=output.txt
   > $file
   while [ $? -eq 0 ]; do
      ./magic.sh >> $file 2>&1
   done

   cat $file
   n=$(wc -l < $file | sed 's/ //g' | xargs -I{} expr {} - 1)
   echo "It took $n runs to fail"
   ```
4. On MacOS, the following command creates `htmls.zip` that has all `.html` files under `$dir` or its subdirectories.
   ```
   $ find "$dir" -name "*.html" -print0 | xargs -0 zip htmls.zip
   ```
5. On MacOS, the following command lists all files under `$dir` or its subdirectories by recency. To get the most recently changed file only, pipe it to `head -n1`.
   ```
   $ find "$dir" -type f -print0 | xargs -0 ls -lt
   ```
</details>

<details>
<summary>Editors (Vim)</summary>

1. Done.
2. Done.
3. Done.
4. Done.
5. Ok I will try.
6. Skipped for now.
7. Skipped for now.
8. I followed the [macros](https://missing.csail.mit.edu/2020/editors/#macros) section and got [example-data.json](example-data.json). Note that you have to undo the changes made by the intermediate macros `e` and `p`.
</details>

<details>
<summary>Data Wrangling</summary>

1. Done.
2. Look at the following command.
   ```
   $ grep -i "a.*a.*a" /usr/share/dict/words | rev | cut -c-2 | rev | sort | uniq -c
   ```
   The `grep` part finds the words that have 3 `a`'s in the case insensitive manner. Note that we do not check if each word ends with `'s` as no word in the file does. What the `rev | cut -c-2 | rev` part does is get the last 2 characters from each word. Finally, by `sort | uniq -c` we get a list of suffixes with multiplicity.

   By further piping the output to `sort | tail -1` we get the most common suffix `al`, which appears 1,039 times. We can use `wc -l` instead to get the number of suffixes, which is 156. Looking at the output of the command above, which is sorted alphabetically, we can easily find a suffix that does not show up. For example, `ab` as in `tab` is not listed there.
3. Running `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt` will clear `input.txt` as the shell first tries to create a new file `input.txt` to get ready for the redirection. We can run `sed -i s/REGEX/SUBSTITUTION/ input.txt` to get around this.
</details>
