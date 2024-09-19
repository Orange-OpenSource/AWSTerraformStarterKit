import argparse
import yaml
from jinja2 import Environment, FileSystemLoader, select_autoescape
import os


default_exec_order = 0
        
def get_current_exec_order(exec_plan:list, plan_name:str):
    for i in range(len(exec_plan)):
        for item in exec_plan[i]:
            if item.get('name') == plan_name:
                return i
    return -1

def schedule(exec_plan: list, plan: dict, exec_order: int):
    if exec_order >= len(exec_plan):
        if len(exec_plan)>0:
            old_exec_order = get_current_exec_order(exec_plan=exec_plan, plan_name=plan.get('name'))
            exec_plan[old_exec_order] = list(filter(lambda a: a.get('name') != plan.get('name'), exec_plan[old_exec_order]))
        exec_plan.append([plan])
    else:
        old_exec_order = get_current_exec_order(exec_plan=exec_plan, plan_name=plan.get('name'))
        if old_exec_order != exec_order:
            exec_plan[old_exec_order] = list(filter(lambda a: a.get('name') != plan.get('name'), exec_plan[old_exec_order]))
        exec_plan[exec_order].append(plan)


def build_exec_plan(plans:list):
    exec_plan = []
    for plan in plans:
        schedule(exec_plan, plan, default_exec_order)
    changed = True
    while changed:
        changed = False
        for plan in plans:
            plan_exec_order = get_current_exec_order(exec_plan, plan_name=plan.get('name'))
            for plan_dependency_name in plan.get('depends_on',[]):
                dependency_exec_order = get_current_exec_order(exec_plan=exec_plan,plan_name = plan_dependency_name)
                if dependency_exec_order >= plan_exec_order:
                    schedule(exec_plan=exec_plan, plan = plan, exec_order= dependency_exec_order + 1)
                    plan_exec_order = dependency_exec_order + 1
                    changed = True
    return exec_plan
                
def print_exec_plan(exec_plan:list):
    for exec_order in range(len(exec_plan)):
        print(f"order[{exec_order}]: {exec_plan[exec_order]}")

def parse_yaml_file(file_path):
    with open(file_path, 'r') as file:
        yaml_content = yaml.safe_load(file)
        return yaml_content

def render_template(template_file, context):
    env = Environment(
        loader=FileSystemLoader(os.path.dirname(template_file)),
        autoescape=select_autoescape(['html', 'xml'])
    )
    template = env.get_template(os.path.basename(template_file))
    return template.render(context)

def main():
    # Create argument parser
    parser = argparse.ArgumentParser(description='Parse YAML file and create an object.')
    parser.add_argument('--config-file', dest='config_file', type=str, required=True, help='Path to the Config YAML file')
    parser.add_argument('--template-file', dest='template_file', type=str, required=True, help='Path to the template file')
    parser.add_argument('--output-file', dest='output_file', type=str, required=True, help='Path to the output file')

    # Parse command line arguments
    args = parser.parse_args()

    # Parse YAML file and create an object
    config_data = parse_yaml_file(args.config_file)
    
    # generate execution plan
    plans = config_data.get('plans',[])
    exec_plan = build_exec_plan(plans=plans)
    
    # Combine environment variables and YAML data
    context = {**os.environ, **config_data, **{"plans_execution_plan":exec_plan}}
    
    # Render Jinja template
    rendered_content = render_template(args.template_file, context)
    with open(args.output_file, 'w') as output_file:
        output_file.write(rendered_content)

    print(f"Template successfully rendered and saved to {args.output_file}")

if __name__ ==  "__main__":
    main()