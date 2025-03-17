import { DataTableDemo } from "@/components/DataTable";
import Layout1 from "@/components/Layout1";
import PaginationComponent from "@/components/PaginationComponent";

export default function Home() {
  return (
    <div>
      <DataTableDemo />
      <Layout1 />
      <PaginationComponent />
    </div>
  );
}
