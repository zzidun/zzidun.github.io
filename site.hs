--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll


--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration
  { destinationDirectory = "docs"
  }

main :: IO ()
main = do
    hakyllWith config $ do
        match "images/*" $ do
            route   idRoute
            compile copyFileCompiler
        match "woff2/*" $ do
            route   idRoute
            compile copyFileCompiler
        match "CNAME" $ do
            route   idRoute
            compile copyFileCompiler

        match "css/*" $ do
            route   idRoute
            compile compressCssCompiler

        match (fromList ["links.md"]) $ do
            route   $ setExtension "html"
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls

        tags <- buildTags "posts/*" (fromCapture "tags/*.html")

        match "posts/*" $ do
            route $ setExtension "html"
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/post.html"    (postCtxWithTags tags)
                >>= loadAndApplyTemplate "templates/default.html" (postCtxWithTags tags)
                >>= relativizeUrls

        tagsRules tags $ \tag pattern -> do
            let title = "Posts tagged \"" ++ tag ++ "\""
            route idRoute
            compile $ do
                posts <- recentFirst =<< loadAll pattern
                let ctx = constField "title" title
                        `mappend` listField "posts" (postCtxWithTags tags) (return posts)
                        `mappend` defaultContext

                makeItem ""
                    >>= loadAndApplyTemplate "templates/tag.html" ctx
                    >>= loadAndApplyTemplate "templates/default.html" ctx
                    >>= relativizeUrls


        create ["archive.html"] $ do
            route idRoute
            compile $ do
                posts <- recentFirst =<< loadAll "posts/*"
                let archiveCtx =
                        listField "posts" postCtx (return posts) `mappend`
                        constField "title" "归档"             `mappend`
                        defaultContext

                makeItem ""
                    >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                    >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                    >>= relativizeUrls

        match "index.html" $ do
            route idRoute
            compile $ do
                posts <- recentFirst =<< loadAll "posts/*"
                let indexCtx =
                        listField "posts" postCtx (return posts) `mappend`
                        defaultContext

                getResourceBody
                    >>= applyAsTemplate indexCtx
                    >>= loadAndApplyTemplate "templates/default.html" indexCtx
                    >>= relativizeUrls

        create ["sitemap.xml"] $ do
            route   idRoute
            compile $ do
                posts <- recentFirst =<< loadAll "posts/*"
                let sitemapCtx =
                        listField "entries" postCtx (return posts) `mappend`
                        defaultContext
                makeItem ""
                    >>= loadAndApplyTemplate "templates/sitemap.xml" sitemapCtx


        match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------

postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags `mappend` postCtx

postCtx :: Context String
postCtx =
    dateField "date" "%Y-%m-%d" `mappend`
    defaultContext
