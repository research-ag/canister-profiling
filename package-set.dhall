[ 
  {
    name = "base",
    repo = "https://github.com/dfinity/motoko-base",
    version = "moc-0.8.4",
    dependencies = [] : List Text
  },
  {
    name = "mrr",
    repo = "https://github.com/research-ag/motoko-lib",
    version = "main",
    dependencies = [ "base" ]
  },
  {
    name = "wip",
    repo = "https://github.com/research-ag/motoko-wip",
    version = "main",
    dependencies = [ "base" ]
  }
]