# What is this?

This is a fairly minimal CTF dashboard web application with almost no
configuration required.

# Minimal configuration

At this point in time, you can create an optional configuration such
as:

```json
{
  "title": "INSERT TITLE HERE"
}
```

You only need to do this if you want a title on every web page.

# Adding challenges

Adding challenges is fairly simple. Each challenge needs a json file
and an erb file. These files can really be named anything. In
[views/challenges](views/challenges) you will find a
[sample.json](views/challenges/sample.json) and [sample.erb](views/challenges/sample.erb). You can
simply mirror those files to create additional challenges. The json
file contiains the name of the challenge, the points it is worth, the
answer, and the name of the erb file. The erb file should contain the
partial html source that the users will see on the dashboard.

# TODO

- Add an Admin interface (it's currently blank)
- Change/forgot password functionality (maybe)
