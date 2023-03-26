[ 
  {
    name = "base",
    repo = "https://github.com/dfinity/motoko-base",
    version = "moc-0.8.5",
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
  },
  {
    name = "th",
    repo = "https://github.com/timohanke/motoko-sha2",
    version = "main",
    dependencies = [ "base", "iterext" ]
  },
  {
    name = "motoko-sha2",
    repo = "https://github.com/timohanke/motoko-sha2",
    version = "v2.0.0",
    dependencies = [ "base", "iterext" ]
  },
  { name = "iterext",
    repo = "https://github.com/timohanke/motoko-iterext.git",
    version = "v2.0.0",
    dependencies = [ "base" ]
  },
  { name = "crypto.mo",
    repo = "https://github.com/skilesare/crypto.mo",
    version = "main",
    -- repo = "https://github.com/aviate-labs/crypto.mo.git",
    -- version = "v0.3.1",
    dependencies = [ "base", "encoding", "base-0.7.3" ]
  },
  { name = "encoding"
  , repo = "https://github.com/aviate-labs/encoding.mo"
  , version = "v0.4.1"
  , dependencies = [ "base-0.7.3", "array" ]
  },
  { name = "array"
  , repo = "https://github.com/aviate-labs/array.mo"
  , version = "v0.2.1"
  , dependencies = [ "base-0.7.3" ]
  },
  { name = "base-0.7.3"
  , repo = "https://github.com/dfinity/motoko-base"
  , version = "moc-0.7.3"
  , dependencies = [] : List Text
  }
]
