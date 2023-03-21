require 'minitest_helper'

describe ActiveRecord::Serializable do

  before do
    1.upto(4) do |i|
      Group.create! name: "Group #{i}"
    end

    1.upto(3) do |i|
      user = User.create! name: "User #{i}",
                          groups: Group.all.shuffle.take(2)

      Avatar.create! user_id: user.id,
                     image_url: "http://www.avatar.com/#{i}"

      1.upto(2) do |j|
        Post.create! user_id: user.id,
                     title: "Post ##{j}",
                     body: 'This is an example'
      end
    end
  end

  describe 'Serialize' do

    it 'Without relations' do
      user = User.first

      expected_user = User.serializable_class.new id: user.id,
                                                  name: user.name

      assert_equal expected_user, user.to_serializable
    end

    describe 'With relations' do

      it 'Belongs to' do
        avatar = Avatar.first

        expected_avatar = Avatar.serializable_class.new id: avatar.id,
                                                        image_url: avatar.image_url,
                                                        user_id: avatar.user_id,
                                                        user: avatar.user.to_serializable

        assert_equal expected_avatar, avatar.to_serializable(include: [:user])
      end

      it 'Has one' do
        user = User.first

        expected_user = User.serializable_class.new id: user.id,
                                                    name: user.name,
                                                    avatar: user.avatar.to_serializable

        assert_equal expected_user, user.to_serializable(include: [:avatar])
      end

      it 'Has many' do
        user = User.first

        expected_user = User.serializable_class.new id: user.id,
                                                    name: user.name,
                                                    posts: user.posts.map(&:to_serializable)

        assert_equal expected_user, user.to_serializable(include: [:posts])
      end

      it 'Has and belongs to many' do
        user = User.first

        expected_user = User.serializable_class.new id: user.id,
                                                    name: user.name,
                                                    groups: user.groups.map(&:to_serializable)

        assert_equal expected_user, user.to_serializable(include: [:groups])
      end

    end

  end

  describe 'Extensible' do

    it 'Include module' do
      post = Post.first

      serializable = post.to_serializable(include: [:user])

      assert_equal post.user.name, serializable.author
    end

    it 'Define method' do
      user = User.first

      serializable = user.to_serializable

      assert_equal "Hi, my name is #{user.name}", serializable.hi
    end

  end

  describe 'Marshalizable' do

    it 'Dump' do
      user = User.first

      expected_dump = "\x04\bo:%ActiveRecord::Serializable::USER\x06:\x14@__attributes__{\aI\"\aid\x06:\x06ETi\x06I\"\tname\x06;\aTI\"\vUser 1\x06;\aT"

      assert_equal expected_dump, Marshal.dump(user.to_serializable)
    end

    it 'Load' do
      dump = "\x04\bo:(ActiveRecord::Serializable::COMMENT\x06:\x14@__attributes__{\b:\aidi\x06:\fpost_idi\x06:\ttextI\"\x15I like this post\x06:\x06ET"

      comment = Marshal.load dump

      expected_comment = Comment.serializable_class.new id: 1,
                                                        post_id: 1,
                                                        text: 'I like this post'

      assert_equal expected_comment, comment
    end

    it 'Load error' do
      dump = "\x04\bo:'ActiveRecord::Serializable::PERSON\x06:\x14@__attributes__{\a:\aidi\x06:\tnameI\"\rPerson 1\x06:\x06ET"

      assert_raises(NameError, 'uninitialized constant ActiveRecord::Serializable::PERSON') do
        Marshal.load dump
      end
    end

  end

end