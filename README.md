[![Build Status](https://travis-ci.org/dachi023/mithril-qiita.svg)](https://travis-ci.org/dachi023/mithril-qiita)
[![npm version](https://img.shields.io/npm/v/mithril-qiita.svg)](https://www.npmjs.com/package/mithril-qiita)

# mithril-qiita
This library to call [Qiita API v2](https://qiita.com/api/v2/docs) in [mithril.js](https://github.com/lhorie/mithril.js)

use npm:
```sh
npm install mithril-qiita
```

## How to use
JavaScript:
```js
mq = require('mithril-qiita');
mq.users().list().then(function(users) {
  console.log(users);
});
```

## License
MIT
