import Control.Concurrent
import System.IO
import Users
import Messages
import System.Random
import Data.UUID
import Data.UnixTime

-- Random Functions
-- ---------------------

-- Calculates a random number between 0 and an inputted number
random_val_in_range :: Int -> IO Int
random_val_in_range max_val = getStdRandom (randomR (0,max_val))

-- Generates a random string of characters of given length
random_message :: Int -> IO String
random_message string_length = do
    gen <- newStdGen
    let random_message = take string_length $ randomRs ('a','z') gen
    return random_message

-- UUID Generator modified from https://stackoverflow.com/questions/58906666/haskell-uuid-generation
gen_uuid :: UUID
gen_uuid = 
    let seed = 1
        seeded_gen = mkStdGen seed
        (uuid_generated, _) = random seeded_gen
    in uuid_generated


-- Message Thread - Runs 10 times per user defined
-- Takes channel to denote when all user messages are completed
-- takes channel to store message created
-- takes user to show who sent the message
-- takes a list of remaining users who can be sent the randomised message
message_thread :: Chan () -> Chan Message -> User -> [User] -> IO ()
message_thread messages_complete messages_chan s_user u_list = do
    -- Sleep random time
    delay <- random_val_in_range 10000000
    threadDelay delay
    -- Pick random user from list
    user_index <- random_val_in_range (length u_list)
    let selected_user = u_list !! user_index
    -- Generate string
    message_content_generated <- random_message 100
    -- Generate UUID for the message
    let m_id = gen_uuid
    
    -- Get unix timestamp
    time <- getUnixTime >>= return . show . utSeconds
    let time_int = read time
    -- Create Message
    let message_created =  create_message m_id message_content_generated time_int selected_user s_user
    
    putStrLn ("Message Written")
    writeChan messages_chan message_created
    writeChan messages_complete ()

user_thread :: Chan () -> Chan Message -> User -> IO ()
user_thread completed_chan messages_chan user = do
    putStrLn ("Starting User" ++ (show (user_id user)) ++ " Thread")
    let possible_users = filter (\a -> a/=user) full_user_list
    -- putStrLn ("Sendable users: " ++ show possible_users)
    all_messages_sent <- newChan

    forkIO $ ( message_thread all_messages_sent messages_chan user possible_users)
    forkIO $ ( message_thread all_messages_sent messages_chan user possible_users)
    forkIO $ ( message_thread all_messages_sent messages_chan user possible_users)
    forkIO $ ( message_thread all_messages_sent messages_chan user possible_users)
    forkIO $ ( message_thread all_messages_sent messages_chan user possible_users)
    forkIO $ ( message_thread all_messages_sent messages_chan user possible_users)
    forkIO $ ( message_thread all_messages_sent messages_chan user possible_users)
    forkIO $ ( message_thread all_messages_sent messages_chan user possible_users)
    forkIO $ ( message_thread all_messages_sent messages_chan user possible_users)
    forkIO $ ( message_thread all_messages_sent messages_chan user possible_users)

    mapM_ (\_ -> readChan all_messages_sent) [1..10]

    writeChan completed_chan ()

main :: IO ()
main = do
    threads_completed <- newChan
    messages_chan <- newChan

    forkIO $ (user_thread threads_completed messages_chan (create_user 1 "Person 1"))
    forkIO $ (user_thread threads_completed messages_chan (create_user 2 "Person 2"))
    forkIO $ (user_thread threads_completed messages_chan (create_user 3 "Person 3"))
    forkIO $ (user_thread threads_completed messages_chan (create_user 4 "Person 4"))
    forkIO $ (user_thread threads_completed messages_chan (create_user 5 "Person 5"))
    forkIO $ (user_thread threads_completed messages_chan (create_user 6 "Person 6"))
    forkIO $ (user_thread threads_completed messages_chan (create_user 7 "Person 7"))
    forkIO $ (user_thread threads_completed messages_chan (create_user 8 "Person 8"))
    forkIO $ (user_thread threads_completed messages_chan (create_user 9 "Person 9"))
    forkIO $ (user_thread threads_completed messages_chan (create_user 10 "Person 10"))
    
    mapM_ (\_ -> readChan threads_completed) [1..10]

    print "Threads Complete"

    -- mapM_ (\message -> readChan messages_chan) [1..100]


    return ()

full_user_list :: [User]
full_user_list = [
        create_user 1 "Person 1",
        create_user 2 "Person 2",
        create_user 3 "Person 3",
        create_user 4 "Person 4",
        create_user 5 "Person 5",
        create_user 6 "Person 6",
        create_user 7 "Person 7",
        create_user 8 "Person 8",
        create_user 9 "Person 9",
        create_user 10 "Person 10"
    ]

create_user :: Int -> String -> User
create_user id_parse username_parse = User {user_id = id_parse, username = username_parse}

create_message :: UUID -> String -> Int -> User -> User -> Message
create_message message_id_parse message_content_parse time_created_parse user_sent_to_parse user_sent_from_parse = Message {message_id = message_id_parse, message_content = message_content_parse, time_created = time_created_parse, user_sent_to = user_sent_to_parse, user_sent_from = user_sent_from_parse}