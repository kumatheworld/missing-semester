# missing-semester
My Exercise Solutions for [The Missing Semester of Your CS Education, Winter 2020](https://missing.csail.mit.edu/2020/) from MIT.

<details>
<summary>Course overview + the shell</summary>

1. ``` sh
   $ echo $SHELL
   /bin/bash
   ```
2. ``` sh
   $ mkdir /tmp/missing
   ```
3. ``` sh
   $ man touch
   ```
4. ``` sh
   $ touch /tmp/missing/semester
   ```
5. ``` sh
   $ echo '#!/bin/sh' > /tmp/missing/semester
   $ echo 'curl --head --silent https://missing.csail.mit.edu' >> /tmp/missing/semester
   ```
6. ``` sh
   $ /tmp/missing/semester
   -bash: /tmp/missing/semester: Permission denied
   $ ls -l /tmp/missing/semester
   -rw-r--r--  1 kumatheworld  wheel  61 Jun 30 19:20 /tmp/missing/semester
   ```
7. This works because it only needs the read permission unlike the previous one that needs the execute permission.
   ``` sh
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
8. ``` sh
   $ man chmod
   ```
9. The first line of `/tmp/missing/semester` right after the shebang `#!` tells the shell what program to run. In our case, that is `/bin/sh`.
   ``` sh
   $ chmod u+x /tmp/missing/semester
   $ /tmp/missing/semester
   (command output shown)
   ```
0. ``` sh
   $ /tmp/missing/semester | grep "last-modified" > ~/last-modified.txt
   ```
</details>

<details>
<summary>Shell Tools and Scripting</summary>

1. The following command lists the files under `$dir` in that way.
   ``` sh
   $ ls -alhtG "$dir"
   ```
2. ``` sh
   marco() {
      export MARCO=$(pwd)
   }

   polo() {
      cd "$MARCO"
   }
   ```
3. Assuming the given script is named `magic.sh`, the following script is what we want.
   ``` sh
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
   ``` sh
   $ find "$dir" -name "*.html" -print0 | xargs -0 zip htmls.zip
   ```
5. On MacOS, the following command lists all files under `$dir` or its subdirectories by recency. To get the most recently changed file only, pipe it to `head -n1`.
   ``` sh
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
   ``` sh
   $ grep -i "a.*a.*a" /usr/share/dict/words | rev | cut -c-2 | rev | sort | uniq -c
   ```
   The `grep` part finds the words that have 3 `a`'s in the case insensitive manner. Note that we do not check if each word ends with `'s` as no word in the file does. What the `rev | cut -c-2 | rev` part does is get the last 2 characters from each word. Finally, by `sort | uniq -c` we get a list of suffixes with multiplicity.

   By further piping the output to `sort | tail -1` we get the most common suffix `al`, which appears 1,039 times. We can use `wc -l` instead to get the number of suffixes, which is 156. Looking at the output of the command above, which is sorted alphabetically, we can easily find a suffix that does not show up. For example, `ab` as in `tab` is not listed there.
3. Running `sed s/REGEX/SUBSTITUTION/ input.txt > input.txt` will clear `input.txt` as the shell first tries to create a new file `input.txt` to get ready for the redirection. We can run `sed -i s/REGEX/SUBSTITUTION/ input.txt` to get around this.
4. I skip this as it turned out there was little information from the log.
   ``` sh
   $ log show | grep -e"=== system boot:" -e"Previous shutdown cause" | cut -d' ' -f-2
   2021-07-06 20:25:13.000000+0900
   2021-07-21 19:06:06.000000+0900
   2021-07-21 19:06:06.736536+0900
   ```
5. The following command almost does the job.
   ``` sh
   $ log show --process 0 | cut -c89- | sort | uniq -c | awk '$1 == 1' | tr -s ' ' | cut -c4-
   ```
   Note that we do not filter out old information from earlier than the past 3 reboots since we do not have it in the first place.

   This command has some more problems that I am not sure how to fix. Firstly, it might possibly filter out messages that show up multiple times in a reboot and do not in other reboots. Another serious problem is that the command output is too long to see in practice, being well over 100k lines. This is because it contains many lines that are basically the same but slightly different in number.
6. The following command downloads the table from the [first website](https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/topic-pages/tables/table-1) and shows the statistics of the population column.
   ``` sh
   $ curl -s https://ucr.fbi.gov/crime-in-the-u.s/2016/crime-in-the-u.s.-2016/tables/table-1 | tr '\n' '\a' | grep -o '<table.*</table>' | tr '\a' '\n' | grep -A1 'headers="cell31 ' | grep "</td>" | sed 's/[^0-9]//g' | R --slave -e 'x <- scan(file="stdin", quiet=TRUE); summary(x)'
   Min.   1st Qu.    Median      Mean   3rd Qu.      Max.
   267783607 287309833 300509820 298634769 312159283 323127513
   ```
   To get the statistics of the n-th column in general, change `'headers="cell31 '` to `'headers="cell3{n} '` (removing the curly braces).
</details>

<details>
<summary>Command-line Environment</summary>

#### Job control
1. ``` sh
   $ sleep 10000
   ^Z
   [1]+  Stopped                 sleep 10000
   $ bg
   [1]+ sleep 10000 &
   $ pgrep -af "sleep 10000"
   12443
   $ pkill -af "sleep 10000"
   [1]+  Terminated: 15          sleep 10000
   ```
2. Using `wait`:
   ``` sh
   $ sleep 60 &
   [1] 12651
   $ wait %1; ls
   [1]+  Done                    sleep 60
   README.md         example-data.json
   ```
   Defining `pidwait`:
   ``` sh
   pidwait() {
      :
      while [ $? -eq 0 ]; do
         sleep 1
         kill -0 $1 2>/dev/null
      done
      ls
   }
   ```
   ``` sh
   $ sleep 10 &
   [1] 15304
   $ pidwait $(pgrep -af "sleep 10")
   [1]+  Done                    sleep 10
   README.md         example-data.json
   ```
#### Terminal multiplexer
1. Done.
#### Aliases
1. ``` sh
   alias dc=cd
   ```
2. Below is the command output. As you can see, nothing is really worth setting an alias for. Doing something like `alias gc="git commit"` might help but I am willing to type the full commands for those.
   ``` sh
   $ history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10
   1 07/27/21 22:00:42 tmjux
   1 07/27/21 22:00:43 tmux
   1 07/27/21 22:00:50 screen
   1 07/27/21 22:03:30 tmux
   1 07/27/21 22:06:41 tmux ls
   1 07/27/21 22:37:09 nano diary.md
   1 07/27/21 22:38:53 git commit -am "Add 2021-07-27"
   1 07/27/21 22:38:55 git push
   1 07/28/21 08:03:35 brew install --cask virtualbox
   1 07/28/21 19:43:04 history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10   ```
#### Dotfiles
1. Done.
2. Done.
3. Done.
4. Done.
5. Skipped for now. I will add things like `.bashrc` later.
6. See https://github.com/kumatheworld/dotfiles.
</details>
