Jekyll::Hooks.register :site, :after_init do |site|
  site.collections['artists'] = Jekyll::Collection.new(site, 'artists')
end

Jekyll::Hooks.register :site, :post_read do |site|
  artists = site.collections['artworks'].docs
                .map { |doc| doc.data['artist'] }
                .compact
                .uniq
                .sort

  artists.each do |artist|
    doc = Jekyll::Document.new(
      File.join(site.source, '_artists', "#{Jekyll::Utils.slugify(artist)}.md"),
      site: site,
      collection: site.collections['artists']
    )
    doc.data.merge!({
      'name'  => artist,
      'slug'   => Jekyll::Utils.slugify(artist),
      'layout' => 'artist'
    })
    site.collections['artists'].docs << doc
  end
end
