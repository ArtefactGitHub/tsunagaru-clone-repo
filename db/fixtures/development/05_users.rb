User.seed(:id,
  { id: 3, name: '信長', introduction: '信長です', role: :general, uuid: 'uuid3',
    email: 't@g.com',
    crypted_password: User.encrypt('foobar') },
  { id: 4, name: '家康', introduction: '家康です', role: :general, uuid: 'uuid4',
    email: 't2@g.com',
    crypted_password: User.encrypt('foobar') },
)
