defmodule Blog.PostsTest do
  use Blog.DataCase

  alias Blog.Posts

  describe "posts" do
    alias Blog.Posts.Post

    import Blog.PostsFixtures

    @invalid_attrs %{content: nil, subtitle: nil, title: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "list_posts/1 filters posts by title" do
      found = post_fixture(title: "aaa")
      partial_match_beginning = post_fixture(title: "aaab")
      partial_match_end = post_fixture(title: "baaa")
      case_insensitive_match = post_fixture(title: "AAA")
      not_found = post_fixture(title: "bbb")

      results = Posts.list_posts(title: "aaa")

      assert found in results
      assert partial_match_beginning in results
      assert partial_match_end in results
      assert case_insensitive_match in results
      refute not_found in results
    end

    test "list_posts/1 filters posts by content" do
      found = post_fixture(content: "aaa")
      partial_match_beginning = post_fixture(content: "aaab")
      partial_match_end = post_fixture(content: "baaa")
      case_insensitive_match = post_fixture(content: "AAA")
      not_found = post_fixture(content: "bbb")

      results = Posts.list_posts(content: "aaa")

      assert found in results
      assert partial_match_beginning in results
      assert partial_match_end in results
      assert case_insensitive_match in results
      refute not_found in results
    end

    test "lists_posts/1 returns all posts for empty filters" do
      found = post_fixture(title: "aaa", content: "aaa")
      assert Posts.list_posts(title: "", content: "") == [found]
    end

    test "lists_posts/1 filters posts by all filters" do
      found = post_fixture(title: "aaa", content: "aaa")
      found_by_title = post_fixture(title: "aaa", content: "not_found")
      found_by_content = post_fixture(title: "not_found", content: "aaa")
      not_found = post_fixture(title: "not_found", content: "not_found")

      assert Posts.list_posts(title: "aaa", content: "aaa") == [
               found,
               found_by_title,
               found_by_content
             ]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{content: "some content", subtitle: "some subtitle", title: "some title"}

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.subtitle == "some subtitle"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "create_post/1 with too-large title and subtitle returns error changeset" do
      too_long_string = Enum.map(1..101, fn _ -> "a" end) |> Enum.join("")
      attrs = %{content: nil, subtitle: too_long_string, title: too_long_string}

      assert {:error, %Ecto.Changeset{errors: errors}} = Posts.create_post(attrs)
      assert Keyword.get(errors, :subtitle)
      assert Keyword.get(errors, :title)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()

      update_attrs = %{
        content: "some updated content",
        subtitle: "some updated subtitle",
        title: "some updated title"
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.subtitle == "some updated subtitle"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
