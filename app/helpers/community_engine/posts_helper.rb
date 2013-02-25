module CommunityEngine::PostsHelper

  # The ShareThis widget defines a bunch of attributes you can customize.
  # Facebook seems to ignore them (it uses title and description meta tags
  # instead).  MySpace, however, only works if you set these attributes.
  def sharethis_options(post)
		js = <<-eos
	SHARETHIS.addEntry({
		title:'#{escape_javascript(post.title)}',
		summary:'#{escape_javascript(truncate_words(post.post, 75, '...' ))}'
	}, {button:true});
		eos
		
    javascript_tag do   
      js.html_safe
    end
  end

end
