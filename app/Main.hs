module Main (main) where

import Users
import Messages
import System.IO
import System.Random

random_val_in_range :: Int -> IO Int
random_val_in_range max_val = getStdRandom (randomR (0,max_val))

random_string :: IO String
random_string = 

message_list :: [Message]
message_list = []

main = do
    hSetBuffering stdout NoBuffering
    let test_user = User {user_id = 0, username = "Test Username"}
    simulate_thread test_user


    -- map (create_thread message_list) user_list
    -- create_thread message_list test_user
    -- mapM_ print user_list

create_user :: Int -> String -> User
create_user id_parse username_parse = User {user_id = id_parse, username = username_parse}


create_message :: Int -> String -> String -> User -> User -> Message
create_message message_id_parse message_content_parse time_created_parse user_sent_to_parse user_sent_from_parse = Message {message_id = message_id_parse, message_content = message_content_parse, time_created = time_created_parse, user_sent_to = user_sent_to_parse, user_sent_from_parse = user_sent_from}


user_list :: [User]
user_list = [
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

simulate_thread :: User -> IO ()
simulate_thread sending_user = do
    user_index <- random_val_in_range (length user_list -1)
    let random_user = user_list !! user_index

    create_message 
    

