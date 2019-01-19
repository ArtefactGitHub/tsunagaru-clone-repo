User.seed(:id,
  { id: 1, name: 'システム', introduction: '', role: :admin, uuid: 'uuid1',
    email: Rails.application.credentials.dig(:user, :admin, :email_system),
    crypted_password: User.encrypt(Rails.application.credentials.dig(:user, :admin, :pass_system)) },
  { id: 2, name: '運営', introduction: '', role: :admin, uuid: 'uuid2',
    email: Rails.application.credentials.dig(:user, :admin, :email_operation),
    crypted_password: User.encrypt(Rails.application.credentials.dig(:user, :admin, :pass_operation)) },
)
