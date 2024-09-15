-- Database: project_management

-- DROP DATABASE IF EXISTS project_management;
-- CREATE DATABASE project_management;

CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    description TEXT,
    user_id INT,  -- Foreign key to Users table
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Define ENUM type for task status
CREATE TYPE task_status AS ENUM ('todo', 'doing', 'done');

CREATE TABLE Tasks (
    task_id SERIAL PRIMARY KEY,
    task_name VARCHAR(100) NOT NULL,
    description TEXT,
    project_id INT,  -- Foreign key to Projects table
    status task_status DEFAULT 'todo',
    task_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

CREATE TABLE SubTasks (
    subtask_id SERIAL PRIMARY KEY,
    subtask_name VARCHAR(100) NOT NULL,
    task_id INT,  -- Foreign key to Tasks table
    status task_status DEFAULT 'todo',
    subtask_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id)
);

CREATE TABLE TaskAssignments (
    assignment_id SERIAL PRIMARY KEY,
    task_id INT,  -- Foreign key to Tasks table
    user_id INT,  -- Foreign key to Users table
    assigned_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Comments (
    comment_id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    user_id INT,  -- Foreign key to Users table
    task_id INT,  -- Foreign key to Tasks table (optional)
    subtask_id INT,  -- Foreign key to SubTasks table (optional)
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (subtask_id) REFERENCES SubTasks(subtask_id)
);

CREATE TABLE ActivityLog (
    log_id SERIAL PRIMARY KEY,
    user_id INT,  -- Foreign key to Users table
    project_id INT,  -- Foreign key to Projects table
    task_id INT,  -- Foreign key to Tasks table
    subtask_id INT,  -- Foreign key to SubTasks table (optional)
    action VARCHAR(255) NOT NULL,  -- E.g., 'Task Created', 'Task Updated'
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (subtask_id) REFERENCES SubTasks(subtask_id)
);

CREATE TABLE Tags (
    tag_id SERIAL PRIMARY KEY,
    tag_name VARCHAR(50) NOT NULL
);

CREATE TABLE TaskTags (
    task_id INT,  -- Foreign key to Tasks table
    tag_id INT,   -- Foreign key to Tags table
    PRIMARY KEY (task_id, tag_id),
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id),
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id)
);
